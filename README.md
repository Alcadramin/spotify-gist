## 🎶 Your top Spotify tracks in a GitHub Gist!

> This project is based on [spotify-box](https://github.com/izayl/spotify-box), it uses Ruby with minor modifications instead of JavaScript.

#
### Usage

1. Create a new public GitHub Gist (<https://gist.github.com/>).
2. Create a token with the `gist` scope and copy it. (<https://github.com/settings/tokens/new>).
3. Create a Spotify Application, detail steps you can see below.

#
### <details><summary>Get Spotify Refresh Token</summary>
<p>

### 1. Create new Spotify Application

- Visit [https://developer.spotify.com/dashboard/applications](https://developer.spotify.com/dashboard/applications) and create a new application, after creating your app, you will get your Client ID & Client Secret.

- Then click `EDIT SETTINGS` Button, add `http://localhost:3000` to Redirect URIs.

### 2. Get Authorization Code

- Visit following URL after replacing `$CLIENT_ID` with yours.

```
https://accounts.spotify.com/en/authorize?client_id=$CLIENT_ID&response_type=code&redirect_uri=http:%2F%2Flocalhost:3000&scope=user-read-currently-playing%20user-top-read
```

- Agree to this application to access your info, after that your will be redirect to a new page.
- **URL:** `http://localhost:3000?code=$CODE`, the `$CODE` is your Authorization Code, it will be used to generate access_token at next step.

### 3. Get Access Token

- Use the `$CLIENT_ID` and `$CLIENT_SECRET` from step 1, `$CODE` from step 2 to replace the shell command below.

```sh
curl -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d grant_type=authorization_code -d code=$CODE -d redirect_uri=http://localhost:3000 https://accounts.spotify.com/api/token
```

- After that run it at your terminal, you'll get your `$REFRESH_TOKEN`. The output will be like this:

```json
{
    "access_token": "BQBi-jz.....yCVzcl",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "AQCBvdy70gtKvnrVIxe...",
    "scope": "user-read-currently-playing user-top-read"
}
```

- If the response didn't return refresh_token, back to step 2 and retry.

</p>
</details>

#

If you are going to use it with GitHub Actions please do not skip [Environment Variables](README.md#-environment-variables) section.

## Environment Variables

- See [.env.example](.env.example).

## License

This repository is licensed under the [GPLv3 License](LICENSE.md).
