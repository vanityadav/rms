import { cva, VariantProps } from "@/cva.config";
import { ComponentPropsWithoutRef, forwardRef } from "react";

export const buttonVariants = cva({
  base: " rounded-lg   cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed",
  variants: {
    intent: {
      unset: null,
      primary: "bg-primary-500  text-white   hover:bg-primary-700",
      outlined:
        "bg-white  text-primary-500 hover:bg-primary-100  border border-primary-500",
    },
    size: {
      default: "px-4 py-2",
    },
  },
  defaultVariants: {
    intent: "unset",
    size: "default",
  },
});

export type ButtonVariantProps = VariantProps<typeof buttonVariants>;

const Button = forwardRef<
  HTMLButtonElement,
  ComponentPropsWithoutRef<"button"> & ButtonVariantProps
>(({ className, size, intent, ...props }, ref) => {
  return (
    <button
      ref={ref}
      {...props}
      className={buttonVariants({ intent, size, className })}
    />
  );
});

Button.displayName = "Button";

export default Button;
