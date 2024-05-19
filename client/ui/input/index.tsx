import { cva, VariantProps } from "@/cva.config";

export const inputVariants = cva({
  base: "rounded-lg  border  border-[#EAECF0] placeholder:text-[#475467] hover:border-black  focus-visible::border-var(--color-primary-700)",
  variants: {
    intent: {
      unset: null,
      primary: "border text-black",
    },
    inputSize: {
      unset: null,
      default: "px-3 py-2",
    },
  },
  defaultVariants: {
    intent: "unset",
    inputSize: "unset",
  },
});

interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement>,
    VariantProps<typeof inputVariants> {}

const Input = (props: InputProps) => {
  const { intent, inputSize, className, ...restProps } = props;
  return (
    <input
      {...restProps}
      className={inputVariants({ intent, inputSize, className })}
    />
  );
};

Input.displayName = "Input";

export default Input;
