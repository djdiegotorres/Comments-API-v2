Inicialmente eu comecei rascunhando algumas APIs que a IA me forneceu e decidi usar o Node que me pareceu mais simples e atenderia bem, comecei a fazer testes, consegui por em produção localmente.

 A API inicialmente exigia uma "content_id" para o POST do comentário e o GET só exibia um comentário por vez, pedindo a "content_id" para isso.

Então eu consegui ajustar para esse Backend não exigir a "content_id" para o POST e que GET me mostrasse todos os comentários de uma só vez, conforme pedido no desafio.

Resolvido isso localmente eu comecei a estudar o terraform para provisionar e por em produção em uma instância EC2 na AWS. Criei as credenciais necessárias, chave SSH e instalei o AWS CLI.

Provisionei a instancia EC2 e subi a API em um container docker, já automatizado via terraform e deploy pelo github. Até a Api subir, tive vários contratempos, utilizando a IA para me auxiliar, fui ajustando e consegui por em produção.

Faltava subir o monitoramento que decidi utilizar Prometheus + Grafana. Rodei os comandos necessários diretamente dentro da EC2, subi o monitoramento e configurei o Grafana para enxergar as métricas do Prometheus. Assim eu consegui concluir. Repositorio comments-API.

Entretanto eu percebi que eu poderia (e deveria) ter automatizado  a implantação do monitoramento durante a criação da instância pelo terraform. 

Para realizar isto, como este já estava em produção e eu precisava apresentá-lo no dia seguinte, por precaução eu optei em não mexer mais nele, criei um novo repositório "Comments-api-v2" e subi uma nova instância independente.

Levei algum tempo com erros relacionados as novas alterações, (terraform dando conflito com security group que estava em produção na outra instância, erros no docker-compose e outros) 

Se houvesse mais tempo gostaria de ter subido um frontend para ficar mais didático o funcionamento da API e também gostaria de ter utilizado um DELETE para o usuário ter a opção de apagar seu comentário e o PATCH para editá-lo.