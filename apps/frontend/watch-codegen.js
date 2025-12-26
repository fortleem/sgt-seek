const { exec } = require('child_process');
const chokidar = require('chokidar');

console.log('👀 Starting GraphQL Codegen watcher...');
const watcher = chokidar.watch(['app/**/*.tsx'], { ignored: /node_modules/, ignoreInitial: true });

watcher.on('all', (event, path) => {
  console.log(`🔄 Detected change in ${path}, regenerating types...`);
  exec('npm run codegen', (err, stdout, stderr) => {
    if (err) console.error('❌ Codegen error:', stderr);
    else console.log('✅ Types regenerated');
  });
});
