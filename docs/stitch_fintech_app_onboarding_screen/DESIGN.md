---
name: Organic Growth
colors:
  surface: '#fff8f2'
  surface-dim: '#e4d9c7'
  surface-bright: '#fff8f2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fef2e0'
  surface-container: '#f8ecda'
  surface-container-high: '#f2e7d5'
  surface-container-highest: '#ede1cf'
  on-surface: '#201b10'
  on-surface-variant: '#424842'
  inverse-surface: '#363024'
  inverse-on-surface: '#fbefdd'
  outline: '#737971'
  outline-variant: '#c2c8bf'
  surface-tint: '#49654d'
  primary: '#223c27'
  on-primary: '#ffffff'
  primary-container: '#38533c'
  on-primary-container: '#a7c6a8'
  inverse-primary: '#b0ceb1'
  secondary: '#5d5f58'
  on-secondary: '#ffffff'
  secondary-container: '#e2e3d9'
  on-secondary-container: '#63655d'
  tertiary: '#6e5d00'
  on-tertiary: '#ffffff'
  tertiary-container: '#c7aa0b'
  on-tertiary-container: '#4b3f00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cbebcc'
  primary-fixed-dim: '#b0ceb1'
  on-primary-fixed: '#06200e'
  on-primary-fixed-variant: '#324d36'
  secondary-fixed: '#e2e3d9'
  secondary-fixed-dim: '#c6c7be'
  on-secondary-fixed: '#1a1c16'
  on-secondary-fixed-variant: '#454840'
  tertiary-fixed: '#ffe25f'
  tertiary-fixed-dim: '#e4c531'
  on-tertiary-fixed: '#221b00'
  on-tertiary-fixed-variant: '#534600'
  background: '#fff8f2'
  on-background: '#201b10'
  surface-variant: '#ede1cf'
typography:
  headline-xl:
    fontFamily: Poppins
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Poppins
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Poppins
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-margin: 24px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

This design system is built for a personal finance platform that prioritizes approachability, optimism, and clarity. The brand personality is "The Encouraging Mentor"—professional enough to trust with assets, yet friendly enough to engage with daily. It aims to evoke a sense of financial growth and peace of mind.

The visual style is **Modern Corporate with a Tactile Human Touch**. It blends the structured reliability of fintech with the warmth of organic color palettes and expressive character illustrations. The interface uses generous whitespace to reduce cognitive load and emphasizes key actions through high-contrast button styles. 

Key visual identifiers include:
- **Illustrative Storytelling:** Using the provided character and card assets to create an emotional connection.
- **Natural Palettes:** Moving away from traditional "bank blue" toward earthy greens and creams.
- **Soft Geometry:** Combining sharp typography with highly rounded containers to feel safe and modern.

## Colors

The color strategy centers on an organic, sophisticated palette that differentiates from cold, tech-heavy competitors.

- **Primary (#38533C):** A deep forest green used for main actions, active states, and primary headings. It conveys stability and growth.
- **Secondary/Background (#EAEBE1):** A warm cream used as the base surface color to reduce eye strain and provide a premium, paper-like feel.
- **Tertiary (#FFDF4A):** A bright sun-yellow used sparingly for high-attention callouts, such as the "Add" button in the reference.
- **Neutral (#4D4639):** A warm, dark brown used for body text to maintain softness against the cream background while ensuring high legibility.
- **Semantic Accents:** Muted green (#8BA889) and deep black (#1A1A1A) are reserved for card components and secondary container variations.

## Typography

The typography system creates a clear hierarchy by pairing a geometric, bold sans-serif for impact with a highly legible neo-grotesque for functional data.

- **Headlines (Poppins):** Set in Semi-Bold. These should be tight and impactful. Use "Headline-XL" for hero onboarding screens and "Headline-LG" for standard page titles.
- **Body (Inter):** Used for all descriptive text, paragraphs, and financial data. Its neutral character ensures that complex numbers remain easy to read.
- **Labels:** Use Inter Semi-Bold for buttons and navigational elements. Small labels may use an uppercase transformation with slight letter spacing to improve scanning in dense layouts.

## Layout & Spacing

This design system utilizes a **Fluid Grid** model based on an 8px square rhythm.

- **Mobile:** 4-column layout with 24px side margins and 16px gutters.
- **Desktop:** 12-column centered layout with a max-width of 1200px.
- **Vertical Rhythm:** Elements are stacked using increments of 8px. Use 32px or 48px spacing between major sections (e.g., between the hero illustration and the headline).
- **Safe Areas:** On screens with heavy illustrative content, ensure text is placed within the bottom 40% of the viewport to keep the focal point on the imagery.

## Elevation & Depth

Visual hierarchy is achieved through a combination of **Tonal Layering** and **Soft Ambient Shadows**.

- **Surface Layers:** The background is always the secondary cream color. Cards and floating elements use white or the muted green/black accents.
- **Shadows:** Use a "Natural Drop" shadow for floating elements like cards and buttons. This is a soft, diffused shadow (Blur: 20px, Y: 10px) with a very low opacity (10%) using the neutral brown color as a tint rather than pure black.
- **Overlays:** Illustrations and cards should overlap slightly to create a sense of physical depth and "stacking," as seen in the onboarding reference.

## Shapes

The shape language is friendly and approachable, favoring "Rounded" corners across all UI tiers.

- **Primary Buttons & Cards:** 1rem (16px) corner radius. This provides a soft, modern feel that complements the character illustration style.
- **Small Elements (Chips, Inputs):** 0.5rem (8px) corner radius.
- **Action Bubbles:** Floating labels or secondary indicators (like the "Lorem Ipsum" bubble) use a full Pill-shape (2rem+) to distinguish them from structural cards.

## Components

### Buttons
- **Primary:** Deep forest green background, white Inter Semi-Bold text. 16px rounded corners. Large padding (16px top/bottom, 32px left/right).
- **Icon Buttons:** Small circular buttons (like the yellow '+' button) should use high-contrast colors and simple black icons.

### Cards
- **Financial Cards:** Use the provided card illustrations. Ensure text within cards (balances, names) is white or light grey for legibility against dark backgrounds.
- **Content Cards:** Standard containers for lists or data should use a subtle border or a slightly different tonal background than the main surface.

### Input Fields
- **Default State:** Cream background with a 1px border of the primary green at 20% opacity. 8px rounded corners.
- **Focus State:** 1px solid primary green border with a soft green outer glow.

### Chips & Badges
- **Status Badges:** Pill-shaped with a light tint of the primary color and dark text. Used for categories or transaction status.

### Illustrative Placement
- Character illustrations should be placed at the top of the viewport or anchored to the right side of content blocks. They should always overlap at least one structural UI element (like a card or header) to break the grid and feel dynamic.