# docker-nginx-redirect

:warning: Repository is under initial development

A very simple container to redirect HTTP traffic to another server, based on `nginx`

## Resources

- [Docker Hub](https://hub.docker.com/r/schmunk42/nginx-redirect/)

## Configuration

### Environment variables

- `SERVER_REDIRECT` - server to redirect to, eg. `www.example.com`

See also `docker-compose.yml` file.

## Usage

With `docker-compose`

    docker-compose up -d
    
With `docker`    

    docker run -e SERVER_REDIRECT=www.example.com -p 8888:80 schmunk42/nginx-redirect

---

Built by [dmstr](http://diemeisterei.de)
