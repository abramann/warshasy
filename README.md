# Warsha-sy (Warshasy)

## Overview
**Warshasy** is in development mobile application enables  users to connect and hire service providers of different categories (crafts, technical services, home maintenance) accross all Syria.

## Imported Libraries
- **State:** Bloc
- **Backend:** Supabase  (PostgreSQL, Storage)
- **Routing:** GoRouter
- **UI & i18n:** google_fonts, flutter_localization (Arabic/English), image_picker
- **Utilities:** shared_preferences, connectivity_plus, intl, get_it, url_launcher,

## Architecture
This project follows **Clean Architecture** with the **BLoC** pattern as follow:

```txt
lib/
├── core/                          # Shared utilities and base classes
│   ├── errors/                    # Error handling & failures
│   ├── network/                   # Network utilities
│   ├── storage/                   # Local storage abstraction
│   ├── theme/                     # App theming
│   └── localization/              # i18n support
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication
│   │   ├── data/                  # Data sources & models
│   │   ├── domain/                # Entities & repositories
│   │   └── presentation/          # BLoC & UI
│   │
│   ├── user/                      # User management
│   ├── static_data/               # Cities, services, categories
│   ├── home/                      # Home & service discovery
│   └── chat/                      # Messaging (in progress)

