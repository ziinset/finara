---
name: Financier Modern
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#3f4a3d'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#6f7a6b'
  outline-variant: '#bfcab9'
  surface-tint: '#006e1c'
  primary: '#006b1b'
  on-primary: '#ffffff'
  primary-container: '#268630'
  on-primary-container: '#f7fff1'
  inverse-primary: '#7ddc7a'
  secondary: '#5f5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e4e2e1'
  on-secondary-container: '#656464'
  tertiary: '#186a22'
  on-tertiary: '#ffffff'
  tertiary-container: '#358438'
  on-tertiary-container: '#f7fff1'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#98f994'
  primary-fixed-dim: '#7ddc7a'
  on-primary-fixed: '#002204'
  on-primary-fixed-variant: '#005313'
  secondary-fixed: '#e4e2e1'
  secondary-fixed-dim: '#c8c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#474747'
  tertiary-fixed: '#a3f69c'
  tertiary-fixed-dim: '#88d982'
  on-tertiary-fixed: '#002204'
  on-tertiary-fixed-variant: '#005312'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  title-md:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  numeral-xl:
    fontFamily: Manrope
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 48px
---

## Brand & Style

This design system is built for clarity and financial empowerment. It combines a **Corporate/Modern** aesthetic with subtle **Minimalist** influences to ensure complex financial data remains approachable and easy to digest. The goal is to evoke feelings of security, precision, and growth.

The interface prioritizes high readability and a "systematic" feel, using ample white space to reduce cognitive load during data entry and financial review. It avoids decorative clutter in favor of functional clarity and a refined professional tone.

## Colors

The palette is anchored by a vibrant, growth-oriented green (Primary) and a stable, professional dark gray (Secondary). 

- **Primary Green:** Reserved for success states, growth indicators, and primary calls to action (e.g., the central "Add" button).
- **Secondary Gray:** Used for structural elements, navigation bars, and primary typography to ground the interface.
- **Surface Neutrals:** High-contrast light grays and pure whites provide a clinical background that ensures financial figures and input fields remain the focus of the user's attention.

## Typography

The design system utilizes **Manrope** for its balance of geometric precision and humanist warmth. It is highly legible at small sizes—crucial for financial tables and labels.

- **Numerals:** Financial figures should use the `700` weight to stand out.
- **Hierarchies:** Use `label-md` in all-caps for category headers or secondary metadata. 
- **Readability:** Body text is set with generous line-height to ensure that dense financial information does not feel cramped.

## Layout & Spacing

The design system follows a **12-column fluid grid** for desktop and a **4-column grid** for mobile. 

- **Data Entry Focus:** Forms should be centered in a maximum 600px container on desktop to prevent eye strain and ensure a clear vertical path for completion.
- **Vertical Rhythm:** A strict 8px base unit (baseline grid) governs all spacing between elements to maintain a professional, systematic alignment.
- **Density:** High density is preferred for dashboards (compact cards), while low density is preferred for transaction entry (large gutters and margins).

## Elevation & Depth

Visual hierarchy is achieved through **Tonal Layers** and **Ambient Shadows**.

- **Surfaces:** The background is `#FFFFFF`. Containers for modules (like a "Recent Transactions" list) use `#F5F5F5` or a 1px border of `#E0E0E0`.
- **Shadows:** Use extremely soft, low-opacity shadows (`rgba(0,0,0,0.04)`) with a high blur radius (20px+) to suggest lift for primary action cards.
- **Active State:** Elements like the floating action button or active navigation items use high-contrast color shifts rather than heavy shadows to indicate prominence.

## Shapes

The design system employs a **Rounded** shape language to soften the "cold" nature of financial data. 

- **Inputs & Buttons:** Use `0.5rem` (8px) corners for a modern, approachable feel.
- **Navigation Containers:** As seen in the reference, the primary navigation bar uses a significantly larger radius (`rounded-xl` / 24px) to create a distinct, encapsulated look.
- **Data Visuals:** Bar charts and progress bars should have capped (rounded) ends to maintain consistency with the UI components.

## Components

### Buttons
- **Primary:** Background Primary Green, Text White, `rounded-md`.
- **Secondary:** Background Secondary Gray, Text White.
- **Ghost:** No background, Primary Green border and text.

### Form Fields
- **Input Areas:** White background, 1px `#E0E0E0` border. On focus, the border thickens to 2px Primary Green.
- **Labels:** Positioned above the field in `label-md` weight.
- **Validation:** Clear red text for errors, positioned immediately below the input.

### Cards
- **Financial Cards:** Used for account balances. Features high-contrast text and subtle ambient shadows.
- **List Items:** Clean white rows with a bottom divider of `#F0F0F0`. Chevron icons are used to indicate drill-down capabilities.

### Navigation
- **Bottom Bar:** As per the reference, a floating dark gray container with a centered, oversized circular action button for "Add Transaction."