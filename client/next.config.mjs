/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    after: true,
    reactCompiler: true,
    ppr: true,
  },
};

export default nextConfig;
