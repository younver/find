# find
Firebase in Docker - run firebase locally in containerised environment for development and testing purposes.

### Run

#### Default
```bash
docker run -it --rm -p 9000:9000 -p 9099:9099 -p 4000:4000 --name find ghcr.io/younver/find:main
```

#### With custom configurations

```bash
# Create database.rules.json
echo '{
  "rules": {
    ".read": false,
    ".write": false
  }
}' > database.rules.json
```

```bash
# Create firebase.json
echo '{
  "database": {
    "rules": "database.rules.json"
  },
  "emulators": {
    "database": {
      "host": "0.0.0.0",
      "port": 9000
    },
    "auth": {
      "host": "0.0.0.0",
      "port": 9099
    },
    "ui": {
      "enabled": true,
      "host": "0.0.0.0",
      "port": 4000
    }
  }
}
' > firebase.json
```

```bash
# Docker run find with firebase.json and database.rules.json
docker run -it --rm -p 9000:9000 -p 9099:9099 -p 4000:4000 -v ./firebase.json:/app/firebase.json -v ./database.rules.json:/app/database.rules.json --name find ghcr.io/younver/find:main
```

#### With Compose
```yaml
services:
  ...
  firebase:
    image: "ghcr.io/younver/find:main"
    ports:
      - "9000:9000"
      - "9099:9099"
      - "4000:4000"
  ...
```

## Usage

#### Python
```python
from firebase_admin import initialize_app, db

app = initialize_app(options={"databaseURL": "http://localhost:9000?ns=find"})
db.reference("users").child("123").set(
    {"username": "ada.lovelace", "email": "ada@example.com"}
)
print(db.reference("users").child("123").get())
```

#### Go
```go
package main

import (
	"context"
	"log"

	firebase "firebase.google.com/go/v4"
)

const (
	FIREBASE_PROJECT_ID   = "find"
	FIREBASE_DATABASE_URL = "localhost:9000?ns=find"
)

func main() {
	ctx := context.Background()

	firebaseApp, err := firebase.NewApp(ctx, &firebase.Config{ProjectID: FIREBASE_PROJECT_ID, DatabaseURL: FIREBASE_DATABASE_URL})
	if err != nil {
		log.Fatalf("Error initializing firebase app: %v", err)
	}

	db, err := firebaseApp.Database(ctx)
	if err != nil {
		log.Fatalf("Error initializing firebase database client: %v", err)
	}

	user := map[string]interface{}{
		"username": "ada.lovelace",
		"email":    "ada@example.com",
	}
	if err := db.NewRef("users").Child("123").Set(ctx, &user); err != nil {
		log.Fatalf("Error setting value: %v", err)
	}

	var dbUser map[string]interface{}
	if err := db.NewRef("users").Child("123").Get(ctx, &dbUser); err != nil {
		log.Fatalf("Error reading value: %v", err)
	}

	log.Printf("User: %v", dbUser)
}

```

## Further configurations

To configure firebase emulators and rules, you can edit firebase.json and database.rules.json following [the document about configuring and integrating firebase local emulator suite](https://firebase.google.com/docs/emulator-suite/install_and_configure#security_rules_configuration).

## Roadmap
- [X] Authentication
- [X] Emulator Suite UI
- [X] Realtime Database
- [ ] Cloud Firestore
- [ ] Cloud Storage for Firebase
- [ ] Cloud Functions
