# Batch-Input-SAP-ABAP

**Objetivo:** Criar programa que execute via batch input (shdb) a transação MM02, gravando o campo abaixo com o valor nome + unidade de medida. Exemplo: “LALAIA PEÇ”.
Para a unidade de medida de PEÇ. 

***Usar a transação MM02, alterar o nome do material**  

**Detalhamento:** 

Criar nova parametrização na **STVARV**, como `select-option`, para armazenar a unidade de medida 'PEÇ'.

* Criar um programa: Nome: `ZR<iniciais>_SBBATCH_INPUT`
    * Seleção: Código do material (`parameter`)
    * Regra:
        * Buscar o material informador na seleção (tabela **MARA**)
        * Buscar a parametrização
        * Se a unidade de medida do material estiver contida na parametrização, então gravar o campo com a concatenação de nome do material + unidade de medida, atualizar via **Batch Input MM02**.
* Testes:
    * Parametrizar somente o **PEÇ**.
        * Testar com 2 materiais, um com unidade de medida diferente de PEÇ e outro com a unidade de medida PEÇ.
    * Parametrizar **PEÇ** e **CX**.
        * Testar com 3 materiais. Um PEÇ, outro CX, e outro diferente.
