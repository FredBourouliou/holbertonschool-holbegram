# Holbegram

Clone d'Instagram développé en Flutter dans le cadre du projet final de la spécialisation Flutter à Holberton School.

L'application permet à un utilisateur de s'inscrire, se connecter, publier des photos, consulter un fil d'actualité, rechercher d'autres utilisateurs, sauvegarder des publications en favoris et gérer son profil.

---

## Stack technique

| Couche | Technologie |
|---|---|
| Framework | Flutter / Dart |
| Authentification | Firebase Authentication (email + mot de passe) |
| Base de données | Cloud Firestore |
| Stockage des images | Cloudinary |
| State management | `provider` (ChangeNotifier) |
| Navigation onglets | `bottom_navy_bar` |

---

## Fonctionnalités

- Inscription et connexion par email / mot de passe
- Upload d'une photo de profil depuis la galerie ou l'appareil photo
- Fil d'actualité avec les publications de tous les utilisateurs en temps réel
- Publication d'une photo avec légende
- Suppression d'une publication
- Recherche d'utilisateurs
- Page Favoris (publications sauvegardées)
- Page Profil avec bouton de déconnexion

---

## Prérequis

- Flutter SDK (canal stable)
- Dart SDK (inclus avec Flutter)
- Un compte Firebase
- Un compte Cloudinary
- Xcode (pour iOS) ou Android Studio (pour Android)

Vérifier l'installation de Flutter :

```bash
flutter doctor
```

---

## Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/<user>/holbertonschool-holbegram.git
cd holbertonschool-holbegram/holbegram
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer Firebase

1. Créer un projet sur [Firebase Console](https://console.firebase.google.com/).
2. Activer **Authentication** → méthode *Email/Password*.
3. Activer **Cloud Firestore** en mode test.
4. Ajouter les applications Android et iOS au projet Firebase et télécharger :
   - `google-services.json` → à placer dans `holbegram/android/app/`
   - `GoogleService-Info.plist` → à placer dans `holbegram/ios/Runner/`

Ces deux fichiers contiennent des clés et sont exclus du versionnement (voir `.gitignore`).

### 4. Configurer Cloudinary

1. Créer un compte sur [Cloudinary](https://cloudinary.com/).
2. Créer un *upload preset* non signé depuis le dashboard.
3. Renseigner l'URL et le preset dans `lib/screens/auth/methods/user_storage.dart` :

```dart
final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/<cloud-name>/image/upload";
final String cloudinaryPreset = "<upload-preset>";
```

---

## Lancement

Lister les appareils disponibles :

```bash
flutter devices
```

Lancer l'application :

```bash
flutter run
```

---

## Structure du projet

```
holbegram/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── user.dart
│   │   └── posts.dart
│   ├── methods/
│   │   └── auth_methods.dart
│   ├── providers/
│   │   └── user_provider.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── upload_image_screen.dart
│   │   ├── home.dart
│   │   ├── auth/
│   │   │   └── methods/
│   │   │       └── user_storage.dart
│   │   └── pages/
│   │       ├── feed.dart
│   │       ├── search.dart
│   │       ├── add_image.dart
│   │       ├── favorite.dart
│   │       ├── profile_screen.dart
│   │       └── methods/
│   │           └── post_storage.dart
│   ├── widgets/
│   │   ├── text_field.dart
│   │   └── bottom_nav.dart
│   └── utils/
│       └── posts.dart
└── pubspec.yaml
```

---

## Dépendances principales

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `provider`
- `image_picker`
- `http`
- `uuid`
- `bottom_navy_bar`
- `cached_network_image`
- `flutter_staggered_grid_view`
- `pull_to_refresh`

---

## Auteur

**Frédéric Bourouliou** — Holberton School
