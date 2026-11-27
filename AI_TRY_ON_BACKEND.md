# AI virtual try-on backend contract

The Flutter client deliberately has no provider API key. Deploy a private HTTPS
endpoint and provide its URL at build/run time:

```sh
flutter run --dart-define=AI_TRYON_BACKEND_URL=https://api.example.com/try-on
```

The app sends a multipart `POST` request containing `person_image`,
`product_id`, `garment_image_url`, `category`, and `preserve_identity=true`.
The backend must authenticate to the chosen try-on provider, keep personal
images private, enforce a retention policy, and return JSON:

```json
{"result_image_url":"https://signed-private-result-url"}
```

The client treats missing or invalid results as failures; it never substitutes
the selected product image for a personalized try-on result.
