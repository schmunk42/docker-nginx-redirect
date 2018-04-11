# docker-nginx-redirect

A very simple container to redirect HTTP traffic to another server, based on `nginx`

## Resources

- [Docker Hub](https://hub.docker.com/r/schmunk42/nginx-redirect/)

## Configuration

### Environment variables

- `SERVER_REDIRECT` - server to redirect to, eg. `www.example.com`
- `SERVER_NAME` - optionally define the server name to listen on eg. `~^www.(?<subdomain>.+).example.com`
   useful for capturing variable to use in server_redirect. 
- `SERVER_REDIRECT_PATH` - optionally define path to redirect all requests eg. `/landingpage`
   if not set nginx var `$request_uri` is used
- `SERVER_REDIRECT_SCHEME` - optionally define scheme to redirect to 
   if not set nginx var `$scheme` is used
- `SERVER_REDIRECT_CODE` - optionally define the http status code to use for redirection
   - if not set or not in list of allowed codes 301 is used as default
   - allowed Codes are: 301, 302, 303, 307, 308

See also `docker-compose.yml` file.

## Usage

With `docker-compose`

    docker-compose up -d
    
With `docker`    

    docker run -e SERVER_REDIRECT=www.example.com -p 8888:80 schmunk42/nginx-redirect
    docker run -e SERVER_REDIRECT=www.example.com -e SERVER_REDIRECT_PATH=/landingpage -p 8888:80 schmunk42/nginx-redirect
    docker run -e SERVER_REDIRECT=www.example.com -e SERVER_REDIRECT_PATH=/landingpage -e SERVER_REDIRECT_SCHEME=https -p 8888:80 schmunk42/nginx-redirect

---

Built by [dmstr](http://diemeisterei.de)
