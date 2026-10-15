# 🏛️ ByteQuest System Architecture

This document describes the architectural patterns, component boundaries, and state management flow within the ByteQuest application.

---

## 🏗️ Architectural Overview

ByteQuest follows a **Feature-First Clean Architecture** approach, separating presentation, domain, and data concerns into distinct, modular layers:

```
lib/
├── core/                         # Cross-cutting foundational modules
│   ├── constants/                # App-wide string constants and config values
│   └── theme/                    # Material 3 dark design system tokens & colors
└── features/                     # Self-contained feature modules
    ├── auth/                     # User session & profile management
    ├── codie/                    # Codie dynamic interactive companion
    ├── mascot/                   # Byte mascot rendering & animations
    └── quiz/                     # Quiz engine & question state machine
        ├── data/                 # Question catalog and level stages
        ├── domain/models/        # Immutable domain entities (Question, QuizStage)
        └── presentation/         # UI screens, controllers & modular widgets
```

---

## 🔄 Quiz State Flow

```
[ User Interaction ] 
       │
       ▼
[ QuizController ] ◄────── [ MockQuestions Dataset ]
       │
       ├──► Emits state changes (score, selected index, streak, hint state)
       │
       ▼
[ Presentation Widgets ]
       ├── CodeSnippetCard (Syntax highlight & line numbering)
       ├── OptionCard (Animated selection & validation feedback)
       ├── CodieCompanion (Emotional reactive mascot state)
       └── QuizHeader (Progress bar, level indicators & score tracker)
```

---

## 👾 Companion Mascot State Machine

The in-app companion (`CodieCompanion` & `ByteMascot`) dynamically transitions between expressive states based on quiz progress and answers:

| State | Trigger | Animation / Visual Reaction |
|---|---|---|
| **Idle / Curious** | User is reading a question snippet | Subtle breathing & blinking loop |
| **Thinking** | Option is selected before submit | Concentrating expression |
| **Celebratory** | Correct option submitted | Cheering bounce, neon sparkle effect |
| **Encouraging** | Incorrect option submitted | Supportive nod, encouraging prompt |
| **Victorious** | Stage completed with high accuracy | Level-up celebration aura |

---

## 🎨 Theme & Design System

The application relies on a dark glassmorphic design system defined in `lib/core/theme/`:
- **Neon Accents**: `AppColors.neonBlue`, `AppColors.neonGreen`, `AppColors.neonPurple`, `AppColors.neonOrange`.
- **Card Surfaces**: Translucent dark surfaces with subtle border glows and high contrast typography.
- **Accessibility**: High-contrast syntax tokens for code reading in dark mode environments.
