Mock loader
===========

This tiny helper reads the bundled JSON mock history located at
`assets/mock/mock_history.json` and returns an in-memory map of
messages grouped by `chatId`.

Usage example (async):

```
import 'package:your_app/utils/mock_loader.dart';

final map = await MockLoader.loadMockMessages();
final messagesForChat3 = map[3] ?? [];
```

Notes:
- This loader is read-only and does not modify any database.
- It returns MessageModel instances compatible with the app's model.
- If the file is missing or malformed, it returns an empty map.
