#!/bin/bash
set -e

REGION="us-east-1"
CLUSTER="cluster-bia"
SERVICE="service-bia"
TASK_FAMILY="task-def-bia"

if [ -z "$1" ]; then
    echo "=== Rollback Simple - Projeto BIA ==="
    echo ""
    echo "Uso: $0 <revision>"
    echo ""
    echo "Últimas 10 revisões disponíveis:"
    aws ecs list-task-definitions \
        --family-prefix ${TASK_FAMILY} \
        --region ${REGION} \
        --max-items 10 \
        --sort DESC \
        --query 'taskDefinitionArns[]' \
        --output text | tr '\t' '\n'
    exit 1
fi

REVISION=$1

echo "=== Rollback Simple - Projeto BIA ==="
echo "Fazendo rollback para: ${TASK_FAMILY}:${REVISION}"
echo ""

aws ecs update-service \
    --cluster ${CLUSTER} \
    --service ${SERVICE} \
    --task-definition ${TASK_FAMILY}:${REVISION} \
    --region ${REGION} \
    --query 'service.taskDefinition' \
    --output text

echo ""
echo "✓ Rollback completo!"
