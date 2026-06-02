---
name: Organic Fintech
colors:
  surface: '#fff8f5'
  surface-dim: '#ead6c9'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1e9'
  surface-container: '#ffeadd'
  surface-container-high: '#f9e4d7'
  surface-container-highest: '#f3dfd2'
  on-surface: '#241a12'
  on-surface-variant: '#424842'
  inverse-surface: '#3a2e25'
  inverse-on-surface: '#ffede2'
  outline: '#727972'
  outline-variant: '#c2c8c0'
  surface-tint: '#46654e'
  primary: '#26442f'
  on-primary: '#ffffff'
  primary-container: '#3d5c45'
  on-primary-container: '#b0d3b6'
  inverse-primary: '#accfb2'
  secondary: '#705d00'
  on-secondary: '#ffffff'
  secondary-container: '#fdd73b'
  on-secondary-container: '#715d00'
  tertiary: '#5a3239'
  on-tertiary: '#ffffff'
  tertiary-container: '#744950'
  on-tertiary-container: '#f4bbc3'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c8ebcd'
  primary-fixed-dim: '#accfb2'
  on-primary-fixed: '#02210f'
  on-primary-fixed-variant: '#2f4d37'
  secondary-fixed: '#ffe173'
  secondary-fixed-dim: '#e8c426'
  on-secondary-fixed: '#221b00'
  on-secondary-fixed-variant: '#554500'
  tertiary-fixed: '#ffd9de'
  tertiary-fixed-dim: '#f1b8c0'
  on-tertiary-fixed: '#311118'
  on-tertiary-fixed-variant: '#643b42'
  background: '#fff8f5'
  on-background: '#241a12'
  surface-variant: '#f3dfd2'
typography:
  headline-xl:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
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
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  gutter: 16px
  margin-mobile: 24px
  margin-desktop: 120px
---

## Brand & Style

This design system is built on the philosophy of "Human-Centric Finance." It avoids the cold, sterile aesthetics of traditional banking in favor of a warm, editorial, and approachable atmosphere. The brand personality is encouraging, stable, and sophisticated, targeting young professionals and mindful savers who value both aesthetics and financial health.

The visual style is **Modern Editorial with Tactile touches**. It uses high-contrast typography and a grounded color palette to create a sense of reliability, while incorporating soft shadows and generous whitespace to ensure the interface feels breathable and easy to navigate. The goal is to evoke a feeling of "calm confidence" in every transaction.

## Colors

The color palette is derived from natural, earthy tones to establish trust and psychological comfort.

- **Primary (#3D5C45):** A deep, forest green used for primary actions and brand emphasis. It represents growth and stability.
- **Secondary/Accent (#FFD93D):** A vibrant sun-yellow used sparingly for high-priority calls-to-action (like the 'Add' button) and celebratory moments.
- **Neutral/Text (#40342B):** A dark charcoal brown. This is used for all primary reading text and headings to maintain warmth, avoiding the harshness of pure black.
- **Surface/Background (#E9E9DE):** A soft cream/off-white that serves as the foundation for the UI, reducing eye strain and providing a premium, paper-like feel.

## Typography

The typography system pairs the structural confidence of Montserrat (serving as a modern alternative to Poppins) with the high legibility of Inter. 

Headlines use a Semi-bold weight to create a strong visual anchor on the page. Letter spacing is slightly tightened on larger headlines to give a more "designed" editorial appearance. Body text is set in Inter with a generous line height to ensure maximum readability for financial data and descriptive text. For mobile devices, headline sizes scale down to prevent excessive line-breaking.

## Layout & Spacing

The design system utilizes a **Fixed Grid** model for desktop and a **Fluid 4-Column Grid** for mobile. 

- **Mobile:** 24px side margins with 16px gutters. Elements should align to the grid to maintain a structured, tidy appearance despite the organic color palette.
- **Desktop:** A centered 12-column container (max-width: 1200px) ensures content doesn't become over-extended on wide displays.
- **Rhythm:** An 8px base unit governs all padding and margin decisions. Use `lg` (40px) or `xl` (64px) for vertical section spacing to maintain the "airy" brand feel.

## Elevation & Depth

Hierarchy is established through **Tonal Layering** and **Soft Ambient Shadows**. 

Surfaces do not use heavy dropshadows; instead, they use a "Diffuse Bloom" effect: a low-opacity shadow (10-15%) with a large blur radius (20px-40px) that matches the tone of the surface below. 

To create depth:
1. **Level 0 (Background):** The Cream (#E9E9DE) base.
2. **Level 1 (Cards/Containers):** Pure white or tinted semi-transparent surfaces with soft shadows.
3. **Level 2 (Floating Elements):** High-contrast elements like the yellow action buttons, which use a slightly more defined shadow to appear "interactive" and closer to the user.

## Shapes

The shape language is defined by significant **Roundedness**. 

Everything from buttons to large containers follows the `rounded-lg` (16px/1rem) and `rounded-xl` (24px/1.5rem) patterns. This softens the "seriousness" of the financial context and makes the application feel modern and tactile. Circular shapes are reserved exclusively for icon backgrounds and specific action triggers (e.g., the '+' floating button).

## Components

### Buttons
- **Primary:** Filled with Deep Green (#3D5C45), text in Cream (#E9E9DE). Always uses the maximum roundedness allowed by the shape system.
- **Secondary:** Transparent with a 1.5px border in Deep Green.
- **Floating Action (FAB):** Secondary/Accent color (#FFD93D) with a centered icon.

### Cards
- Cards use a white background or a very light tint. 
- They must feature the standard `rounded-lg` corner radius. 
- Content within cards should follow the 24px (`md`) internal padding rule.

### Input Fields
- Backgrounds should be a slightly darker shade of the cream base to create a "well" effect.
- Focus states are indicated by a 2px Deep Green border.

### Chips & Tags
- Used for categories or transaction types. 
- Small, `pill-shaped` containers with `label-sm` typography. Use low-saturation background tints to prevent visual clutter.