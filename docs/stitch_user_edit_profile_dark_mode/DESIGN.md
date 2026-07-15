---
name: Terra Finance Dark
colors:
  surface: '#101411'
  surface-dim: '#101411'
  surface-bright: '#363a37'
  surface-container-lowest: '#0b0f0c'
  surface-container-low: '#181d19'
  surface-container: '#1c211d'
  surface-container-high: '#272b28'
  surface-container-highest: '#323632'
  on-surface: '#e0e3de'
  on-surface-variant: '#c0c9c0'
  inverse-surface: '#e0e3de'
  inverse-on-surface: '#2d312e'
  outline: '#8a938b'
  outline-variant: '#404942'
  surface-tint: '#95d4ac'
  primary: '#95d4ac'
  on-primary: '#003920'
  primary-container: '#609d78'
  on-primary-container: '#00311b'
  inverse-primary: '#2c6a48'
  secondary: '#c1c8c3'
  on-secondary: '#2b322f'
  secondary-container: '#444b47'
  on-secondary-container: '#b3bab5'
  tertiary: '#ffb2b8'
  on-tertiary: '#551e26'
  tertiary-container: '#c87b82'
  on-tertiary-container: '#4d171f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#b0f1c7'
  primary-fixed-dim: '#95d4ac'
  on-primary-fixed: '#002111'
  on-primary-fixed-variant: '#0f5132'
  secondary-fixed: '#dde4df'
  secondary-fixed-dim: '#c1c8c3'
  on-secondary-fixed: '#161d1a'
  on-secondary-fixed-variant: '#414845'
  tertiary-fixed: '#ffdadb'
  tertiary-fixed-dim: '#ffb2b8'
  on-tertiary-fixed: '#3a0912'
  on-tertiary-fixed-variant: '#71343b'
  background: '#101411'
  on-background: '#e0e3de'
  surface-variant: '#323632'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 42px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
The design system evolves into a high-end, nocturnal environment tailored for modern wealth management and sustainable investing. The brand personality is professional, secure, and sophisticated, evoking the feeling of a private, high-tech sanctuary.

The style is **Modern Corporate** with a focus on **Tonal Layering**. By utilizing a deep forest charcoal palette, the interface reduces eye strain for long-term data monitoring while maintaining an air of premium exclusivity. The aesthetic avoids pure blacks, opting instead for organic, deep-toned grays that feel grounded and natural.

## Colors
The palette shifts to a "Deep Forest" dark mode. The primary accent is an adjusted forest green, lightened and desaturated slightly from the original to ensure AA/AAA accessibility against dark backgrounds. 

- **Primary:** An illuminated forest green (#508D69) used for key actions and brand moments.
- **Secondary:** A soft cream-tinted off-white (#DCE3DE) for primary text and high-contrast labels.
- **Background:** A near-black charcoal with a forest green undertone (#0F110F).
- **Surface:** A slightly lighter charcoal-green (#1A1E1B) used for cards and containers to create depth.
- **Semantic Colors:** Success (Emerald), Warning (Amber), and Error (Coral) should be desaturated to prevent "vibrating" against the dark base.

## Typography
This design system utilizes **Hanken Grotesk** across all levels to maintain a sharp, contemporary, and geometric feel. 

Readability in dark mode is prioritized by using slightly increased line height and subtle letter spacing on smaller labels. Text colors are never pure white; use the secondary cream color (#DCE3DE) for primary content and a 60% opacity version for secondary/caption text to maintain a comfortable visual hierarchy.

## Layout & Spacing
The layout follows a **Fluid Grid** model with a 12-column structure for desktop and a 4-column structure for mobile. 

The spacing rhythm is based on a 4px/8px baseline. Use generous internal padding within cards (24px+) to allow data-heavy financial information to breathe. On desktop, content should be capped at a maximum width of 1440px to ensure line lengths remain readable.

## Elevation & Depth
In this dark mode environment, depth is communicated through **Tonal Layers** rather than heavy shadows. 

1.  **Level 0 (Base):** The dark charcoal-green background.
2.  **Level 1 (Cards/Navigation):** A slightly lighter surface color. 
3.  **Level 2 (Modals/Popovers):** The lightest surface tier with a very subtle, large-radius black shadow (30% opacity) to provide a soft "lift."

Avoid harsh borders. Instead, use a 1px inner stroke with 5% white opacity to define the edges of containers against the dark background.

## Shapes
The shape language is modern and friendly, utilizing **Rounded** corners to soften the technical nature of financial data. 

- Standard components (Buttons, Inputs) use a 0.5rem (8px) radius.
- Larger containers (Cards, Sections) use a 1rem (16px) radius.
- Specific accent elements, such as "Add" buttons or tags, may use a full Pill-shape to distinguish them from data fields.

## Components
- **Buttons:** Primary buttons use the primary green (#508D69) with dark charcoal text for maximum contrast. Secondary buttons use a ghost style with a 1px cream border.
- **Inputs:** Fields are filled with a slightly darker shade than the surface color to create an "inset" feel. Borders appear only on focus using the primary green.
- **Cards:** Use the Level 1 surface color. Avoid dividers where possible; use spacing and subtle shifts in background tone to separate content sections.
- **Chips/Tags:** Use low-opacity fills of the primary green (e.g., 10% opacity) with solid green text to denote categories without overwhelming the visual field.
- **Charts:** Financial data visualizations should use a palette of forest greens, mints, and teals, ensuring lines are at least 2px thick for clarity on dark screens.