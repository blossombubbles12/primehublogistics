import type { Metadata } from "next";
import FAQClient from "./faq-client";

export const metadata: Metadata = {
  title: "FAQ | PrimeHub Logistics",
  description: "Find answers to common questions about shipping, tracking, pricing, coverage, and our services. Quick help for PrimeHub Logistics customers.",
  openGraph: {
    title: "FAQ | PrimeHub Logistics",
    description: "Quick answers to common questions about shipping, tracking, pricing, and coverage.",
    type: "website",
  },
};

export default function FAQPage() {
  return <FAQClient />;
}