# Migração de teste SMNA — 10/09/2026

Destino: https://github.com/GAD-DIMNT-CPTEC/SMNA-tmp

## Resultado preparado

A main tem a árvore Git exatamente igual a SMNA-JACI/JACI-SMNAv3, commit 81f81b919fd06a20228d3003a61f66be2de30365. O commit de consolidação é 683afde301079b9b24a05eca93e2c51f34608e2b. Seus pais preservam JACI, SMNA/main e os novos registros de trunk/tag SVN. Essa integração escolhe explicitamente o conteúdo JACI; não aplica automaticamente alterações exclusivas das outras linhas ao código final.

Foram preservados os 182 commits originais do SMNA e os 138 do JACI, sem reescrever SHAs, autores, datas ou assinaturas. As branches originais estão sob legacy/* e jaci/*. As oito tags originais mantêm seus objetos e nomes.

## SVN

Servidor: https://svn.cptec.inpe.br/smna
UUID: 46c2415e-830b-4654-bf16-f1e6ad7c1d74
Checkout: revisão 253, sem modificações locais; todas as entradas versionadas na mesma revisão.

O limite de 26/02/2026 corresponde à revisão 174. O SMNA também contém alterações Git de março. As revisões SVN 180–253 já estão no histórico JACI, com correspondência de mensagem e data; não foram duplicadas. O conteúdo de r253 foi comparado com o commit df02a7289ebf3b3be6e37c9562e3c7051550d907 do JACI.

As revisões 175–179 foram registradas em cinco novos commits, preservando mensagem, data e login SVN liviany.viana. Não havia e-mail verificado desse login nos históricos: foi usado e-mail vazio, sem inventar endereço ou atribuir a outra pessoa. Os timestamps completos, incluindo frações de segundo não representáveis nos commits Git, estão no log e no mapa JSON.

Branches SVN:
- svn/SMNA_v3.0.x: revisão 176; árvore idêntica à legacy/SMNA_v3.0.x.
- svn/trunk: revisão 179, último desenvolvimento do trunk até r253.
- svn/SMNA_v3.0.0.t12717: revisão 253, apontando para commit JACI existente.
- Tag svn/SMNA_v3.0.3: revisão 177, distinguida da tag Git original, que inclui documentação adicional.

## Verificações

Comparadas as 10 branches, 8 tags e trunk existentes no checkout: bytes dos arquivos versionados contra os blobs Git, considerando o conteúdo efetivo dos ponteiros LFS. Conferidos também bits executáveis e links simbólicos: nenhuma diferença de modo. Os dois arquivos alterados nas revisões 175–176 foram consultados em r174 e conferidos contra o commit ab33e0f9 do SMNA.

Não houve diferenças de conteúdo nos arquivos compartilhados. As diferenças de presença são o .gitattributes acrescentado no JACI, documentação/ferramentas acrescentadas no Git e o arquivo SVN SMG/cptec/gsi/fix/.git. O Git não permite esse último caminho: suas oito ocorrências estão preservadas, com bytes em base64 e checksum, em svn-unrepresentable-files.json.

Git fsck passou. A comparação main versus JACI-SMNAv3 não apresenta diferenças. Os objetos LFS foram baixados da origem e enviados ao destino.

## Limites da preservação

O mapa relaciona 240 das 253 revisões SVN a commits por mensagem/data ou por importação nova. Treze revisões antigas de criação, remoção e reorganização de caminhos não têm correspondência direta no Git já fornecido: 21–24, 26, 89, 147, 152, 153, 169, 170, 173 e 174. O log completo preserva seus eventos, autores, datas e caminhos. Não se afirma que a conversão Git anterior reproduz toda a semântica SVN.

O manifesto r253 conserva caminhos, checksums e propriedades SVN no formato skel/base64, incluindo diretórios e svn:externals. Conteúdo e histórico dos repositórios externos não foram importados; o checkout original e o servidor SVN devem ser mantidos. O material de auditoria não substitui um dump completo do servidor SVN.

Não foram executados compilação nem testes científicos na JACI/Egeon. As issues ficaram fora do escopo. Os quatro diretórios fornecidos pelo usuário não foram modificados.

## Organização e uso

A branch migration/audit contém este relatório, mapas e resultados de auditoria; a main permanece exatamente com os arquivos JACI.

No clone vazio SMNA-tmp fornecido pelo usuário, após a publicação:

```sh
git fetch origin
git switch main
git merge --ff-only origin/main
git lfs pull
```

Para a migração definitiva, revisar o código na JACI, validar o ciclo de assimilação e conferir as diferenças funcionais entre as linhas antes de alterar o repositório institucional SMNA.
