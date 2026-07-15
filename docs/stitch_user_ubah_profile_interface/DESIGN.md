---
name: Terra Finance
colors:
  surface: '#fff8f6'
  surface-dim: '#e7d6d3'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff0ed'
  surface-container: '#fbeae7'
  surface-container-high: '#f5e5e1'
  surface-container-highest: '#f0dfdb'
  on-surface: '#221a18'
  on-surface-variant: '#424843'
  inverse-surface: '#382e2c'
  inverse-on-surface: '#feede9'
  outline: '#737972'
  outline-variant: '#c2c8c0'
  surface-tint: '#4b6451'
  primary: '#263f2d'
  on-primary: '#ffffff'
  primary-container: '#3d5643'
  on-primary-container: '#aecab2'
  inverse-primary: '#b1ceb5'
  secondary: '#6f5d00'
  on-secondary: '#ffffff'
  secondary-container: '#fedf53'
  on-secondary-container: '#736200'
  tertiary: '#383a33'
  on-tertiary: '#ffffff'
  tertiary-container: '#4f514a'
  on-tertiary-container: '#c2c4ba'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cdead1'
  primary-fixed-dim: '#b1ceb5'
  on-primary-fixed: '#082011'
  on-primary-fixed-variant: '#344c3a'
  secondary-fixed: '#ffe262'
  secondary-fixed-dim: '#e3c53c'
  on-secondary-fixed: '#221b00'
  on-secondary-fixed-variant: '#534600'
  tertiary-fixed: '#e2e3d9'
  tertiary-fixed-dim: '#c6c7be'
  on-tertiary-fixed: '#1a1c17'
  on-tertiary-fixed-variant: '#454841'
  background: '#fff8f6'
  on-background: '#221a18'
  surface-variant: '#f0dfdb'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
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
  unit: 8px
  container-padding-mobile: 20px
  container-padding-desktop: 40px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

This design system establishes a high-end, grounded financial environment that pivots away from traditional cold, clinical fintech aesthetics. The brand personality is rooted in "Organic Stability"—combining the reliability of an institutional bank with the tactile, calming qualities of nature. It targets affluent users seeking a mindful relationship with their wealth.

The design style is **Modern Organic**, characterized by:
- **Serenity:** Large amounts of cream-toned whitespace to reduce cognitive load during complex financial tasks.
- **Precision:** Sharp typography paired with generous, pill-like radiuses to balance technical accuracy with approachability.
- **Tactility:** Subtle depth through soft shadows and layered surfaces that mimic stacked paper or high-quality stationery.

## Colors

The palette is derived from natural landscapes to evoke a sense of growth and permanence.

- **Background (Base):** #F2F3E9 (Cream). Used for the primary canvas to provide a warmer, more premium feel than pure white.
- **Primary:** #3D5643 (Deep Forest). Used for key actions, brand moments, and primary navigation elements. It represents security and growth.
- **Neutral/Text:** #2D2422 (Deep Earth). A rich, warm brown used for all body text and headings to maintain high contrast without the harshness of pure black.
- **Accent:** #FCDD52 (Harvest Gold). Used sparingly for high-attention callouts, premium features, or active selection states.
- **Semantic:** 
    - **Income:** A softer variant of the primary green (#5E8266) to indicate positive cash flow.
    - **Expense:** A muted coral-red (#D95D39) to signal outflows while maintaining the earthy tone of the system.

## Typography

The system utilizes a dual-font strategy. **Hanken Grotesk** is used for headlines and currency displays, providing a sharp, contemporary "architectural" feel. **Inter** is used for body copy and data-heavy labels for its exceptional legibility and systematic performance.

Hierarchy is maintained through weight rather than just size. Currency values should always use the `display-lg` or `headline-lg` styles to emphasize financial status. Small labels (`label-caps`) should be used for secondary metadata and table headers to ensure a structured, professional layout.

## Layout & Spacing

The layout follows a **Fluid Grid** model with strict vertical rhythm based on an 8px base unit. 

- **Mobile:** A 4-column grid with 20px outside margins and 16px gutters.
- **Desktop:** A 12-column centered grid with a maximum content width of 1200px.
- **Spacing Philosophy:** Use generous internal padding within cards (min 24px) to emphasize the premium nature of the app. Information density should be kept low to medium to preserve the "calm" brand pillar.

## Elevation & Depth

This design system uses **Tonal Layering** combined with **Ambient Shadows** to create a sense of physical objects resting on a soft surface.

- **Level 0 (Base):** The Cream background (#F2F3E9).
- **Level 1 (Cards):** Pure white (#FFFFFF) surfaces with a very soft, diffused shadow (Blur: 20px, Y: 4px, Color: #2D2422 at 4% opacity).
- **Level 2 (Active/Floating):** Used for modals or active selection. The shadow intensity increases (Blur: 40px, Y: 12px, Color: #2D2422 at 8% opacity).
- **Interaction:** Elements do not "lift" on hover; instead, they use subtle border weight increases or color shifts to maintain a grounded feel.

## Shapes

The shape language is defined by large, inviting radiuses that suggest softness and safety.

- **Primary Containers:** 24px (rounded-xl) for main dashboard cards and background sections.
- **Standard Components:** 16px (rounded-lg) for buttons, input fields, and list items.
- **Small Elements:** 8px (soft) for tags and badges.
- **Iconography:** Icons should be contained within circular or highly rounded containers to match the overall fluid aesthetic.

## Components

### Buttons
Primary buttons use the Deep Forest Green (#3D5643) with white text. They are high-height (48px or 56px) with a 16px corner radius. Secondary buttons use a subtle outline of the text color or a transparent fill against the cream background.

### Input Fields & Search
Input fields use a white background with a thin 1px border in a lightened version of the neutral brown. The search bar is distinct with a 24px radius and a subtle "inner shadow" or a light-tinted fill to denote its role as a primary utility.

### Cards
Cards are the primary container. They must always have a white background to pop against the cream canvas. Internal padding is never less than 24px. Use "soft shadows" as defined in the Elevation section.

### List Items
Transactions and financial lists use a clean, horizontal layout. Category icons are placed in a 40px circular container with a 10% opacity fill of the primary green. Amounts are right-aligned using `title-md` typography, colored according to the status (Income/Expense).

### Status Indicators
Small, pill-shaped badges (12px height) used for "Cleared," "Pending," or "Flagged" status. Use low-saturation background tints with high-saturation text of the same hue for maximum readability and a premium aesthetic.