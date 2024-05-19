import { twMerge } from "tailwind-merge";
import { clsx, type ClassValue } from "clsx";
import { defineConfig, type VariantProps } from "cva";

const cn = (...inputs: ClassValue[]) => {
  return twMerge(clsx(inputs));
};

const { cva, cx, compose } = defineConfig({
  hooks: {
    onComplete: (className) => cn(className),
  },
});

export { cva, cx, compose, cn, type VariantProps };
