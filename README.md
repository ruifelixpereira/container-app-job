# Container Apps Jobs

References:
- https://github.com/Azure-Samples/container-apps-jobs


## Run and test it locally

Using npm:

```bash	
cd src
URL="https://reqres.in/api/users?page=2"
npm run start
```

Or using Docker:

```bash
cd src
docker build -t myjob .
docker run -e URL="https://stackoverflow.com" myjob
```



![alt text](image.png)