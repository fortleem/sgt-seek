import './globals.css';
import SGTProvider from '../lib/apollo-provider';
import React from 'react';

export const metadata = { title: 'SGT Dashboard', description: 'Smart Global Trade Platform' };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="antialiased">
        <SGTProvider>{children}</SGTProvider>
      </body>
    </html>
  );
}
