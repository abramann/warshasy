# Warsha-sy (In development)

## Overview
**Warshasy** is in development mobile application enables  users to connect and hire service providers of different categories (crafts, technical services, home maintenance) accross all Syria.

<img width="108" height="192" alt="Screenshot_20251216-031329" src="https://github.com/user-attachments/assets/5164a99a-1670-4f90-bb0f-f18628514b5d" />
<img width="108" height="192" alt="Screenshot_20251216-031320" src="https://github.com/user-attachments/assets/1c9eae86-8b9d-47ab-b689-cf095b02aecf" />
<img width="108" height="192" alt="Screenshot_20251216-045355" src="https://github.com/user-attachments/assets/5810ecf9-c9fe-48b5-82b6-bf6e11025544" />

## Imported Libraries
- **State:** Bloc
- **Backend:** Supabase  (PostgreSQL, Storage)
- **Routing:** GoRouter
- **UI:** google_fonts, image_picker
- **Utilities:** shared_preferences, flutter_localization (Arabic/English), connectivity_plus, intl, get_it, url_launcher,

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

