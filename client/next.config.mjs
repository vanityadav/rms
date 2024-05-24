/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    after: true,
    reactCompiler: true,
    ppr: "incremental",
  },
};

export default nextConfig;
