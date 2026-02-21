* Faço meu formulário de busca (SELECTS) começar sempre do macro pro micro. *
FORM zf_busca.

  SELECT *                                   "SELECIONO * (TUDO)
    FROM tvarvc                              "DA tabela TVARVC
    INTO TABLE @gt_tvarvc                    "NA TABELA global gt_tvarvc (jogando na tabela)
    WHERE name = 'ZGSF_MEINS'.               "ONDE name = ZRGSF_MEINS (Parametrização que eu criei).

  IF sy-subrc IS INITIAL.                    "SE sy-subrc É INICIAL (valor padrão = 0).

    SELECT SINGLE matnr, meins               "SELECIONE ÚNICO matnr, meins (SELEÇÃO DE UMA ÚNICA LINHA)
      FROM mara                              "DA TABELA mara
      INTO CORRESPONDING FIELDS OF @gw_mara  "EM CAMPOS CORRESPONDENTE DA WORK ÁREA(estrutura) gw_mara
      WHERE matnr EQ @p_matnr.               "ONDE matnr IGUAL a p_matnr(PARAMETER da tela de seleção).

    SELECT SINGLE matnr, maktx               "SELECIONE ÚNICO matnr, maktx (SELEÇÃO DE UMA ÚNICA LINHA)
      FROM makt                              "DA TABELA makt
      INTO CORRESPONDING FIELDS OF @gw_makt  "EM CAMPOS CORRESPONDENTE DA WORK ÁREA(estrutura) gw_makt
      WHERE matnr EQ @gw_mara-matnr           "ONDE matnr IGUAL a gw-mara-matnr
        AND spras EQ @sy-langu.               "E spras IGUAL a sy-langu(LINGUAGEM DO USUÁRIO SAP GUI).

    SELECT SINGLE spras, msehi, mseh3        "SELECIONE ÚNICO spras, msehi, mseh3 (SELEÇÃO DE UMA ÚNICA LINHA)
      FROM t006a                             "DA TABELA t006a
      INTO CORRESPONDING FIELDS OF @gw_t006a "EM CAMPOS CORRESPONDENTE DA WORK ÁREA(estrutura) gw_t006a
      WHERE msehi EQ @gw_mara-meins          "ONDE msehi IGUAL a gw_mara-meins
        AND spras EQ @sy-langu.              "E spras IGUAL a sy-langu(LINGUAGEM DO USUÁRIO SAP GUI).

  ENDIF.                                     "Fim do IF.

ENDFORM.                                     "Fim do FORM.

* Faço meu formulário de tratamento (LÓGICA). *
FORM zf_tratamento.

* LEITURA DA TABELA gt_tvarvc EM WORK ÁREA(estrutura) gw_tvarvc COM CHAVE low(baixo) IGUAL a gw_t006a-mseh3. *
  READ TABLE gt_tvarvc INTO gw_tvarvc WITH KEY low = gw_t006a-mseh3.

  IF gw_t006a-mseh3 = gw_tvarvc-low.                    "SE WORK ÁREA(estrutura) gw_t006a-mseh3 IGUAL a WORK ÁREA(estrutura) gw_tvarvc-low.

    CONCATENATE gw_makt-maktx gw_tvarvc-low             "CONCATENAR WORK ÁREA(estrutura) gw-makt-maktx/gw_tvarvc-low
          INTO gv_text                                  "EM VARIÁVEL GLOBAL gv_text
          SEPARATED BY space.                           "SEPARADO POR space(espaço) para a concatenação.

    PERFORM zf_grava_bdc.                               "Executar o FORM de gravação do BATCH INPUT zf_grava_bdc.
    PERFORM zf_chama_transacao.                         "Executar o FORM de chamada de transação zf_chama_transação.

  ENDIF.                                                "Fim do IF PRINCIPAL.

  IF sy-subrc IS INITIAL.                               "SE sy-subrc É INICIAL (valor padrão = 0), no caso deu certo.
    MESSAGE 'Batch Input gerado com sucesso.' TYPE 'S'. "MENSAGEM de sucesso TIPO 'S'.
  ELSE.                                                 "SENÃO.
    MESSAGE 'Erro na geração do Batch Input.' TYPE 'E'. "MENSAGEM de erro TIPO 'E'.

  ENDIF.                                                "Fim do IF SY-SUBRC.

ENDFORM.                                                "Fim do FORM.

* Faço meu formulário que define uma subrotina que recebe dois parâmetros: o nome do programa da tela e o número do dynpro (tela). *
FORM bdc_dynpro USING program dynpro.

  FREE gw_bdcdata.                    "LIMPAR WORK ÁREA(estrutura) gw_bdcdata.
  gw_bdcdata-program  = program.      "gw_bdcdata-program IGUAL a programa (NOME DO PROGRAMA).
  gw_bdcdata-dynpro   = dynpro.       "gw_bdcdata-dynpro IGUAL a dynpro (TELA).
  gw_bdcdata-dynbegin = 'X'.          "gw_bdcdata-dynbegin IGUAL a 'X' (Para linhas de campos, DYNBEGIN fica vazio.).
  APPEND gw_bdcdata TO gt_bdcdata.    "ADICIONAR WORK ÁREA(estrutura) gw_bdcdata NA TABELA GLOBAL gt_bdcdata.

ENDFORM.                              "Fim do FORM.

* Faço meu formulário que define uma subrotina que recebe o nome do campo da tela (fnam) e o valor que será digitado (fval). *
FORM bdc_field USING fnam fval.

  FREE gw_bdcdata.                    "LIMPAR WORK ÁREA(estrutura) gw_bdcdata.
  gw_bdcdata-fnam = fnam.             "gw_bdcdata-fnam IGUAL a fnam (Preenche FNAM com o nome técnico do campo de tela).
  gw_bdcdata-fval = fval.             "gw_bdcdata-fval IGUAL a fval (Preenche FVAL com o valor que tu quer inserir naquele campo).
  APPEND gw_bdcdata TO gt_bdcdata.    "ADICIONAR WORK ÁREA(estrutura) gw_bdcdata NA TABELA GLOBAL gt_bdcdata.

ENDFORM.                              "Fim do FORM.

* Faço meu formulário de gravação do BATCH INPUT. *
FORM zf_grava_bdc.

  FREE gt_bdcdata.                                                   "LIMPAR TABELA GLOBAL gt_bdcdata.

* Tela inicial *
  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.                   "EXECUTAR o FORM bdc_dynpro USANDO 'SAPLMGMM' '0060' (Inicia um novo dynpro/tela (cabeçalho de tela) no roteiro).
  PERFORM bdc_field       USING 'BDC_CURSOR' 'RMMG1-MATNR'.          "EXECUTAR o FORM bdc_field USANDO 'BDC_CURSOR' 'RMMG1-MATNR' (Adiciona uma linha bdcdata que indica em qual campo o cursor deve ficar quando a tela abrir).
  PERFORM bdc_field       USING 'BDC_OKCODE' '=ENTR'.                "EXECUTAR o FORM bdc_field USANDO 'BDC_OKCODE' '=ENTR' (Adiciona o function code da tela: =ENTR simula o pressionar da tecla Enter na tela).
  PERFORM bdc_field       USING 'RMMG1-MATNR' p_matnr.               "EXECUTAR o FORM bdc_field USANDO 'RMMG1-MATNR' p_matnr (Preenche o campo RMMGI-MATNR com o conteúdo do parâmetro p_matnr).

* Seleção de views *
  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.                   "EXECUTAR o FORM bdc_dynpro USANDO 'SAPLMGMM' '0070' (Inicia a dynpro/tela 0070 do mesmo programa (DYNBEGIN = 'X')).
  PERFORM bdc_field       USING 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)'. "EXECUTAR o FORM bdc_field USANDO 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(01)' (Posiciona o cursor em MSICHTAUSW-DYTXT(01)).
  PERFORM bdc_field       USING 'BDC_OKCODE' '=ENTR'.                "EXECUTAR o FORM bdc_field USANDO ''BDC_OKCODE' '=ENTR' (Coloca o OK code =ENTR para essa tela também (press Enter)).
  PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)' 'X'.          "EXECUTAR o FORM bdc_field USANDO 'MSICHTAUSW-KZSEL(01)' 'X' (Marca (define como 'X') a flag/checkbox MSICHTAUSW-KZSEL(01)).

* Alteração do texto *
  PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.                   "EXECUTAR o FORM bdc_dynpro USANDO 'SAPLMGMM' '4004' (Inicia a dynpro 4004 (cabeçalho de nova tela)).
  PERFORM bdc_field       USING 'BDC_CURSOR' 'MAKT-MAKTX'.           "EXECUTAR o FORM bdc_field USANDO 'BDC_CURSOR' 'MAKT-MAKTX' (Posiciona o cursor no campo MAKT-MAKTX).
  PERFORM bdc_field       USING 'BDC_OKCODE' '=BU'.                  "EXECUTAR o FORM bdc_field USANDO 'BDC_OKCODE' '=BU' (Insere o OK code =BU para essa tela =BU é um código de função do dynpro).
  PERFORM bdc_field       USING 'MAKT-MAKTX' gv_text.                "EXECUTAR o FORM bdc_field USANDO 'MAKT-MAKTX' gv_text (Preenche o campo MAKT-MAKTX com o conteúdo da variável gv_text).

ENDFORM.
"Fim do FORM.
* Faço meu formulário de chamada de transação (utilizando a MM02). *
FORM zf_chama_transacao.

  CALL TRANSACTION 'MM02'           "CHAMA A TRANSAÇÃO 'MM02'
       USING gt_bdcdata             "USANDO a TABELA GLOBAL gt_dbcdata
       MODE 'N'                     "MODO 'N' (Executa sem mostrar nenhuma tela)    'A' - Mostra todas as telas, 'E' - Mostra só se der erro
       UPDATE 'S'                   "ATUALIZAR 'S' (Atualização síncrona)           'A' - Atualização assíncrona, 'L' - Local update(força execução local)
       MESSAGES INTO gt_bdcmsgcoll. "MENSAGENS PARA TABELA GLOBAL gt_bdcmsgcool (Captura as mensagens geradas pela execução da transação e guarda na tabela interna).

ENDFORM.                            "Fim do FORM.
