#!/bin/bash
FRONTEND_DIR="/Users/tonsy/Documents/sgt-seek/apps/frontend"
GOVERNOR_DIR="/Users/tonsy/Documents/sgt-seek/apps/governor"
GOVERNOR_URL="http://localhost:8080/graphql"

echo "🛑 Stopping existing services..."
pkill -f sgt-governor || true
pkill -f "next.*dev" || true

echo "⚡ Starting Governor (Rust)..."
cd "$GOVERNOR_DIR"
./target/release/sgt-governor > /tmp/sgt-gov.log 2>&1 &
sleep 3

echo "⏳ Fetching Schema and Patching Frontend..."
# Use Node to fetch schema and patch page.tsx safely
node -e "
const fs = require('fs');
const http = require('http');

const query = JSON.stringify({
  query: '{ __type(name: \"MutationRoot\") { fields { name args { name type { name kind ofType { name } } } } } }'
});

const req = http.request('$GOVERNOR_URL', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' }
}, (res) => {
  let data = '';
  res.on('data', d => data += d);
  res.on('end', () => {
    try {
      const schema = JSON.parse(data);
      const mutation = schema.data.__type.fields.find(f => f.name.includes('CommissionLock')) || schema.data.__type.fields[0];
      
      const vars = mutation.args.map(a => '$' + a.name + ': String!').join(', ');
      const params = mutation.args.map(a => a.name + ': $' + a.name).join(', ');
      
      const gqlString = 'mutation ' + mutation.name + '(' + vars + ') { ' + mutation.name + '(' + params + ') { id lockStatus } }';
      
      let content = fs.readFileSync('$FRONTEND_DIR/app/page.tsx', 'utf8');
      content = content.replace(/export const COMMISSION_LOCK_MUTATION = gql\`mutation {}\`/, 'export const COMMISSION_LOCK_MUTATION = gql\`' + gqlString + '\`');
      fs.writeFileSync('$FRONTEND_DIR/app/page.tsx', content);
      console.log('✅ Patched page.tsx with ' + mutation.name);
    } catch (e) { console.log('⚠️ Patching failed: ' + e.message); }
  });
});
req.write(query);
req.end();
"

echo "🧬 Regenerating Types..."
cd "$FRONTEND_DIR"
npm run codegen || echo "⚠️ Codegen skipped"

echo "🚀 Launching SGT Dashboard..."
npm run dev
