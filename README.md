# qt-casino
## Goal

To create a high-quality, free-to-play, online multiplayer casino Craps game for Android (and potentially other platforms) that offers a superior user experience by being **completely ad-free** and transparently fair, addressing common frustrations with existing solutions.

## Vision

Imagine a smooth, engaging Craps experience where players can connect with friends and strangers alike, placing bets with virtual currency, enjoying realistic dice rolls and animations, all without intrusive advertisements. The core emphasis is on fun, fairness, and community.

## Key Features & Requirements

* **Online Multiplayer:** Real-time interaction with other players at a Craps table.
* **Ad-Free Experience:** No banner ads, no interstitial ads, no video ads. Monetization through optional cosmetics:
  - **Table Themes:** Custom craps table backgrounds/themes that display to all players when you're the shooter
  - **Dice Skins:** Custom dice designs
  - **Chip Sets:** Personalized chip designs
  - **Virtual Chip Purchases:** Optional chip top-ups (core gameplay always remains free)
* **Free-to-Play:** Players create characters with different starting chip amounts (difficulty levels), with daily character reset option. No real money or cryptocurrency gambling.
* **High-Quality UI/UX:** Intuitive, visually appealing Craps table layout, smooth animations (dice rolls, chip movements), and clear display of game state and bets.
* **Fair & Transparent Randomness:** Ensuring dice rolls are genuinely random and perceived as fair by players.
* **Robust Backend:** Capable of managing game state, player data, and real-time communication securely.

## Technical Considerations & Proposed Stack

### 1. Frontend: Android Application

* **Framework:** **Qt (C++/QML)**
    * **Pros:** Cross-platform capabilities (potential for iOS, Desktop later), excellent performance with C++, powerful QML for creating fluid and animated UIs.
    * **UI:** QML will be used for declarative UI definition and animations.
    * **Game Logic Integration:** Core Craps rules and client-side interactions will be handled in C++.
* **Authentication:** **Google Sign-In (via JNI)**
    * Users can sign in using their Google accounts. This will require bridging Qt's C++ code with Android's Java/Kotlin APIs using JNI (Java Native Interface) for Google Play Services integration.

### 2. Backend: Game Server

* **Necessity:** A dedicated backend server is **essential** for online multiplayer. It acts as the authoritative source for game state, preventing cheating and ensuring all players experience the same, fair game.
* **Real-time Communication:** **WebSockets** (e.g., using Qt's `QtWebSockets` module for a C++ server, or a Node.js/Python/Go backend with WebSocket libraries).
* **Game State Management:** Server-side logic to handle all Craps rules, validate bets, process rolls, and manage payouts.
* **Player Management:** User accounts, lobbies, matchmaking, persistent virtual chip balances, and player statistics will be managed on the server with a suitable database (e.g., PostgreSQL, MongoDB, Firebase Firestore).

### 3. Randomness Implementation

* **Core Principle:** All dice rolls will be generated on the **server-side** using a cryptographically secure pseudorandom number generator (CSPRNG).
* **Unique Seeding Idea: Public Blockchain Data**
    * The server will periodically fetch public, unpredictable data (e.g., **block hashes** from Bitcoin or Ethereum, or similar public blockchain data) from a reliable blockchain API.
    * This blockchain data will serve as a source of entropy to **seed** the server's CSPRNG, adding an external, publicly verifiable element to the randomness.
    * **Note:** This does *not* involve real crypto gambling or transactions within the game. It merely leverages the public nature of blockchain data for randomness.
* **Transparency & Trust: Provably Fair System (Planned)**
    * To build maximum player trust, the game aims to implement a "provably fair" system.
    * This involves the server committing to a hashed outcome *before* a roll, allowing players to contribute a "client seed," and then revealing all components (server seed, client seed, blockchain data used) *after* the roll, enabling players to independently verify the fairness of the outcome.

## Challenges & Workload

Developing a project of this scope is significant:

* **Complexity:** Integrating game logic, real-time networking, platform-specific features (JNI), and a robust backend.
* **Development Time:** Realistically, this is a **6-12+ month project** for a small, experienced team, or a long-term personal endeavor if developed solo.
* **UI/UX Polish:** Achieving a "high-quality" and "ad-free" experience requires significant attention to detail in design and animation.
* **Backend Scaling & Maintenance:** Ensuring the server can handle concurrent players and ongoing operational tasks.

## Current Status

**✅ Completed:**
* Qt6/QML project structure with CMake and custom app icon
* Authentic craps table layout with proper casino-style betting areas
* Complete basic craps game logic (Come Out/Point phases, Pass/Don't Pass)
* 3D chip stacking system with realistic chip graphics and denominations
* Dice rolling animations with proper dot patterns
* Bet validation (prevents conflicting Pass/Don't Pass bets)
* Semi-transparent betting areas over themeable background felt
* Hot reload QML development workflow
* Cross-platform build system (Windows/Linux)

**🚧 In Progress:**
* Expanding betting areas (Field, Come, Place bets)
* Theme system foundation (disco, space, luxury themes)

**📋 TODO:**
* Complete all craps betting options (odds, proposition bets)
* Character creation system with difficulty levels
* Multiplayer networking and server integration
* Blockchain-seeded randomness for provably fair gaming
* Android deployment and mobile optimization

**🎯 Future Games & Features:**
* **Character System:**
  - **Difficulty Presets:** Tourist ($500), Regular ($1000), High Roller ($5000), Whale ($25000)
  - **Avatar Selection:** Preset images or custom uploads
  - **Daily Reset:** Create new character once per day if bankrupt
  - **Achievement Unlocks:** Earn cosmetics through gameplay milestones
* **Additional Casino Games:** Roulette, Blackjack, Poker
* **Cosmetic System:** 
  - Table themes visible to all players when you're active
  - Custom dice and chip designs
  - Social showcase mechanics
* **Enhanced Multiplayer:** Lobbies, friend systems, tournaments
* **Superstition Stats:** Fun psychological engagement features
  - "Rolls since 7" counter during point phase
  - "Hot/Cold numbers" frequency tracker
  - "Longest streak" without hitting point
  - "Lucky/Unlucky seat" win rate by position
  - "Shooter's luck" - passes before 7-out
  - Optional "Superstition Mode" toggle

## Getting Started

### Prerequisites

#### Windows Development
1. **Install Qt6:**
   - **Recommended:** Download Qt Online Installer from https://www.qt.io/download-qt-installer
   - During installation, select:
     - Qt 6.5+ (latest LTS)
     - Qt Quick, QuickControls2, WebSockets modules
     - Qt Creator IDE (optional but helpful)
   - **Alternative:** `winget install Qt.Qt`

2. **VS Code Setup (if using VS Code):**
   - Install CMake Tools extension
   - Configure CMake to find Qt: Add Qt installation path to your system PATH or set `CMAKE_PREFIX_PATH`

#### Linux Development (Ubuntu/Debian)
1. **Install Qt6:**
   ```bash
   sudo apt update
   sudo apt install qt6-base-dev qt6-declarative-dev qt6-websockets-dev \
                    cmake build-essential ninja-build
   ```

2. **For GUI apps in WSL:**
   ```bash
   # Install X11 support
   sudo apt install x11-apps
   # Use Windows X server like VcXsrv or X410
   export DISPLAY=:0
   ```

### Build and Run
```bash
cmake -B build
cmake --build build
./build/qt-casino  # Linux
# or
.\build\Debug\qt-casino.exe  # Windows
```

### Future Setup (TODO):
* **Qt for Android:** Android SDK/NDK, Java JDK setup
* **Backend Architecture:** AWS-based multiplayer server (see below)
* **Blockchain API Integration:** Choose public blockchain API for randomness

### Deploy Infrastructure:
```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## Multiplayer Server Architecture (AWS)

### Current Client Architecture (Multiplayer-Ready)
* **GameLogic class:** Easily adaptable to receive server state instead of local state
* **WebSockets module:** Already integrated for real-time communication
* **Modular UI:** Betting areas and game state display can sync with server data
* **Theme system:** Ready for server-side cosmetic unlocks and purchases

### Proposed AWS Backend Stack

**Core Services:**
* **Amazon ECS/Fargate:** Containerized game servers for auto-scaling
* **Application Load Balancer:** Distribute players across game server instances
* **Amazon ElastiCache (Redis):** Real-time game state, player sessions, leaderboards
* **Amazon RDS (PostgreSQL):** Player accounts, transaction history, cosmetic unlocks
* **Amazon API Gateway + Lambda:** REST APIs for account management, purchases

**Real-time Communication:**
* **AWS IoT Core or Custom WebSocket API:** Handle real-time game events
* **Amazon EventBridge:** Coordinate game events across services

**Blockchain Integration:**
* **Lambda functions:** Fetch blockchain data for provably fair randomness
* **Amazon S3:** Store game outcome proofs and verification data

**Compute Requirements Analysis:**

For a craps game server, compute needs are surprisingly light:

**Per Game Table (6-8 players):**
* **CPU:** ~0.1 vCPU (mostly idle, spikes during dice rolls)
* **Memory:** ~50MB (game state, player sessions)
* **Network:** ~1KB/s per player (WebSocket messages)

**Scaling Math:**
* **1 ECS task (0.25 vCPU, 512MB)** = ~5 concurrent tables = 30-40 players
* **Cost:** ~$9/month per task
* **1000 concurrent players** = ~25 tasks = ~$225/month

**Database Needs:**
* **Tables:** players, games, bets, transactions, cosmetics
* **Queries:** Simple CRUD, no complex analytics
* **Size:** ~1GB for 10k players with full history

**Monthly Infrastructure Costs:**
* **Database (t3.micro):** $13 (sufficient for 10k+ players)
* **Redis (t3.micro):** $15 (real-time game state)
* **ECS Tasks:** $9 per 30-40 players
* **Load Balancer:** $16
* **Data Transfer:** $20-50

**Cost Examples:**
* **100 concurrent players:** ~$80/month
* **500 concurrent players:** ~$150/month  
* **1000 concurrent players:** ~$290/month
* **5000 concurrent players:** ~$1200/month

**Development Phases:**
1. **Phase 1:** Single-player to local multiplayer (current)
2. **Phase 2:** Simple server with basic multiplayer
3. **Phase 3:** Full AWS deployment with auto-scaling
4. **Phase 4:** Advanced features (tournaments, leaderboards, analytics)

**Revenue Considerations:**
* **Break-even at 1000 players:** ~$0.29 per player per month
* **Cosmetic monetization:** Table themes ($2-5), dice skins ($1-3), chip sets ($1-3)
* **Character resets:** Premium characters, faster daily resets
* **Target:** 5-10% conversion rate, $2-8 average revenue per paying user
