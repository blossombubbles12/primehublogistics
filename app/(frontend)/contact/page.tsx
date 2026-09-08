import type { Metadata } from "next";
import ContactClient from "./contact-client";

export const metadata: Metadata = {
  title: "Contact Us | PrimeHub Logistics",
  description: "Get in touch with PrimeHub Logistics. Questions about shipping, business partnerships, API integration, or support — our team is ready to help.",
  openGraph: {
    title: "Contact Us | PrimeHub Logistics",
    description: "Modern logistics technology platform. Reach out for shipping questions, business partnerships, or API integration.",
    type: "website",
  },
};

export default function ContactPage() {
  return <ContactClient />;
}