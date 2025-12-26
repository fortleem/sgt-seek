import { NextResponse } from 'next/server';
import { Client } from 'pg';

export async function POST(request: Request) {
  const body = await request.json();
  const { commodity, quantity, price } = body;

  const client = new Client({
    connectionString: "postgresql://sgt_admin:sgt_password@localhost:5432/sgt_root",
  });

  try {
    await client.connect();
    // Fetch a default user ID (trader_alpha) for the MVP
    const userRes = await client.query("SELECT id FROM users WHERE email = 'trader_alpha@sgt.com' LIMIT 1");
    const userId = userRes.rows[0].id;

    const query = 'INSERT INTO trades (initiator_id, commodity_type, quantity, target_price, status) VALUES (, , , , ) RETURNING id';
    const res = await client.query(query, [userId, commodity, quantity, price, 'OPEN']);
    
    return NextResponse.json({ success: true, tradeId: res.rows[0].id });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Database insertion failed' }, { status: 500 });
  } finally {
    await client.end();
  }
}
