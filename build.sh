versao=$(git rev-parse HEAD | cut -c 1-7)
ECR_REGISTRY="322095785990.dkr.ecr.us-east-1.amazonaws.com"
aws ecr get-login-password --region us-east-1 --profile bia| docker login --username AWS --password-stdin $ECR_REGISTRY
docker build -t bia .
docker tag bia:latest $ECR_REGISTRY/bia:$versao
docker push $ECR_REGISTRY/bia:$versao
rm .env 2> /dev/null
./gerar-compose.sh
rm bia-versao.zip
zip -r bia-versao.zip docker-compose.yml
git checkout compose.yml
