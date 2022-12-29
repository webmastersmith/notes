# CURL

**Examples**

- https://www.keycdn.com/support/popular-curl-examples
- https://linuxhandbook.com/curl-command-examples/

```sh
curl -Lo outputName https://url # L=redirect, o=output
```

## Get

```sh
# simple get request.
curl http://...


# complex example
curl -o myFile.json 'https://stats.nba.com/stats/playerdashboardbyyearoveryear?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerID=2544&PlusMinus=N&Rank=N&Season=2019-20&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&Split=yoy&VsConference=&VsDivision=' \
 -H 'Connection: keep-alive' \
 -H 'Accept: application/json, text/plain, _/_' \
 -H 'x-nba-stats-token: true' \
 -H 'X-NewRelic-ID: VVw==' \
 -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36' \
 -H 'x-nba-stats-origin: stats' \
 -H 'Sec-Fetch-Site: same-origin' \
 -H 'Sec-Fetch-Mode: cors' \
 -H 'Referer: https://stats.nba.com/player/2544/' \
 -H 'Accept-Encoding: gzip, deflate, br' \
 -H 'Accept-Language: en-US,en;q=0.9,id;q=0.8' \
 -H 'Cookie: a_bunch_of_stuff=that_i_removed;' \
 --compressed

```

## POST

```sh
# simple POST request with 'URL' values. Header is optional.
curl -i -d "username=bob&password=secret&website=stack.com" -X POST http://localhost:8080/ -H 'content-type:text/plain'
# simple POST request with 'JSON' values. Header is required.
curl -i -d '{ "username": "scott", "password":"secret", "website": "stack.com" }' -X POST http://localhost:8080/ -H 'content-type:application/json'
# complex
curl --request POST \
          --url https://api.github.com/repos/${{ github.repository }}/issues \
          --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' \
          --header 'content-type: application/json' \
          --data '{ "title": "Issue created due to workflow failure: ${{ github.run_id }}", "body": "This issue was automatically created by the GitHub Action workflow **${{ github.workflow }}**. \n\n due to failure in run: _${{ github.run_id }}_."}'
```

**man page**

- https://curl.se/docs/manpage.html

**Get ip**

- `curl https://checkip.amazonaws.com` //returns your ip.

## Flags

- **-A** // change user agent
- `curl -A 'Mozilla Firefox(42.0)' https://...`
  - curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0" "https://..."
- **-C | --continue-at** // download where left off if interrupted.
- **-d | --data**
  - `curl -X POST -H "Content-Type:application/json" http://localhost:5500 -d '{"road":"Box car rd"}'`
- **-D** // read headers and store headers.
  - if you want the cookies, also use the -b switch
  - `curl -D - https://www.keycdn.com/`
    - the `-` tells curl to output to stdout
- **-H | --headers**
  - `curl -H "Content-Type: application/json" "http://127.0.0.1:9200/_cluster/health"`
- **-i**
  - `curl -i http://...` // display return headers and response body
- **-I | --head** // only fetch the HTTP headers (HEAD method) of a particular page or resource.
  - `curl -I http://` // response headers only
  - `curl --head http://` // response headers only
- **-k | --insecure** // ignore ssl error
- **-L | --location** // follow redirection if page has moved.
  - `curl -L http://`
- **-o | --output** //save file with predetermined name
  - `curl -o /var/lib/myFileName http://somefile`
- **-O | --remote-name** //save file with remote file name.
  - multiple files: curl url1 url2 url3 -O -O -O
  - The file will be saved in the current working directory. If you want the file saved in a different directory, make sure you change current working directory before you invoke curl with the -O, --remote-name flag!
- **--limit-rate 200K** // K kilobyte, M megabyte, G gigabyte
  - `curl --limit-rate 200K -O https://cdn.keycdn.com/img/cdn-stats.png`
- **-s | --silent** // no output
- **-T** // upload file content
  - `curl -T uploadedFile.txt https://...`
- **-X** // HTTP Method (GET, PUT, POST)
  - must be all capitalized.
  - `curl -X PUT -H "Content-Type: application/json" "http://127.0.0.1:9200/_cluster/settings?pretty" -d '{"persistent": {"cluster.routing.allocation.enable": "primaries"}}'`
  - `curl --request GET/POST/DELETE/PUT https://...`
- **-v** // verbose -display all step in request and return
  - `curl -v http://`

**Curl Windows**

- https://www.oracle.com/webfolder/technetwork/tutorials/obe/cloud/objectstorage/installing_cURL/installing_cURL_on_Cygwin_on_Windows.html
- use the Cygwin shortcut in start menu to open terminal.
- C:\\cygwin64
- use the setu-x86_64.exe to update curl.

**Typical web request:**
`F12 / Network / XHR / find network request, right click and "copy as cURL for windows"`.

**Cheerio**
curl -o Cheerio.mp4 "https://vimeo.com/31992?action=log_stream_play" -X POST -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0" -H "Accept: _/_" -H "Accept-Language: en-US,en;q=0.5" --compressed -H "Referer: https://vimeo.com/192" -H "Content-type: application/x-www-form-urlencoded; charset=UTF-8" -H "X-Requested-With: XMLHttpRequest" -H "Origin: https://vimeo.com" -H "DNT: 1" -H "Connection: keep-alive" -H "Cookie: vuid=263;
