import { Suspense } from "react";

export const experimental_ppr = true;

export default async function Home() {
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve("Hello");
    }, 1000);
  });

  return (
    <div>
      <p className="text-2xl">Static Comp</p>
      <Suspense fallback={<div>Loading...</div>}>
        <Slow />
      </Suspense>
    </div>
  );
}

const Slow = async () => {
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve("Hello");
    }, 2000);
  });
  return <div>Hello Slow Comp</div>;
};
