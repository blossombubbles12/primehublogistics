import Image from "next/image";
import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Section } from "@/components/layout/section";
import { Chip } from "@/components/ui/chip";
import { Button } from "@/components/ui/button";
import { Reveal } from "@/components/motion/reveal";

export function CompanyOverview() {
  return (
    <Section background="snow" spacing="lg" pattern="wave">
      <div className="grid grid-cols-1 items-center gap-14 lg:grid-cols-2">
        <Reveal className="relative order-2 lg:order-1">
          <div className="hover-lift relative aspect-[4/3] overflow-hidden rounded-3xl bg-white">
            <Image
              src="/marcin-jozwiak-oh0DITWoHi4-unsplash.jpg"
              alt="PrimeHub Logistics facility"
              fill
              sizes="(min-width: 1024px) 50vw, 100vw"
              className="object-cover"
            />
          </div>
        </Reveal>
        <Reveal delay={100} className="order-1 lg:order-2">
          <Chip variant="secondary" className="mb-6">
            Our Story
          </Chip>
          <h2 className="text-section-heading text-foreground">
            Delivering with speed and care
          </h2>
          <p className="text-body mt-6 text-lg">
            PrimeHub Logistics was born from a simple belief: every shipment deserves
            speed, visibility and care. From startups to global brands, we
            provide the network and technology to keep deliveries moving without friction.
          </p>
          <ul className="mt-8 space-y-4">
            {[
              "Same-day, next-day and freight delivery",
              "Live GPS tracking on every shipment",
              "Nationwide coverage across the Netherlands and the UK",
            ].map((point) => (
              <li key={point} className="flex items-start gap-3">
                <span className="mt-1 h-1.5 w-1.5 shrink-0 rounded-full bg-secondary" aria-hidden="true" />
                <span className="text-body">{point}</span>
              </li>
            ))}
          </ul>
          <Button className="mt-8" variant="outline" asChild>
            <Link href="/about">
              Learn more about us <ArrowRight className="ml-2 h-4 w-4" aria-hidden="true" />
            </Link>
          </Button>
        </Reveal>
      </div>
    </Section>
  );
}
