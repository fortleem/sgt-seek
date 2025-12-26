import { NextResponse } from 'next/server';
import { Client } from 'pg';

export async function GET() {
  const client = new Client({
    connectionString: "postgresql://sgt_admin:sgt_password@localhost:5432/sgt_root",
  });

  try {
    await client.connect();
    const res = await client.query('SELECT * FROM trades ORDER BY created_at DESC');
    return NextResponse.json(res.rows);
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch trades' }, { status: 500 });
  } finally {
    await client.end();
  }
}
