import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import * as React from "react";
import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex min-h-11 items-center justify-center gap-2 whitespace-nowrap rounded-[2px] text-sm font-semibold outline-none transition-colors duration-150 focus-visible:ring-2 focus-visible:ring-accent focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-55 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        primary: "border border-primary bg-primary text-white shadow-[inset_0_-2px_0_rgb(0_0_0_/_12%)] hover:border-[#0b625c] hover:bg-[#0b625c]",
        outline: "border border-[#b8c9c2] bg-surface text-foreground hover:border-primary hover:bg-[#f1f6f3]",
        quiet: "text-secondary hover:bg-[#eaf1ee] hover:text-primary",
      },
      size: {
        default: "px-5 py-2.5",
        small: "min-h-11 px-3.5 py-2 text-sm",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "default",
    },
  },
);

type ButtonProps = React.ComponentProps<"button"> &
  VariantProps<typeof buttonVariants> & {
    asChild?: boolean;
  };

function Button({
  asChild = false,
  className,
  size,
  variant,
  type = "button",
  ...props
}: ButtonProps) {
  const classes = cn(buttonVariants({ size, variant }), className);

  if (asChild) {
    return <Slot data-slot="button" className={classes} {...props} />;
  }

  return (
    <button
      data-slot="button"
      className={classes}
      type={type}
      {...props}
    />
  );
}

export { Button, buttonVariants };
