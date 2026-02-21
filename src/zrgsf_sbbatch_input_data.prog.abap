* Declarando minhas tabelas que vão ser utilizadas no REPORT *
TABLES: mara, makt, t006a.

* Declarando meus tipos que vão ser utilizados no REPORT *
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         meins TYPE mara-meins,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_t006a,
         spras TYPE t006a-spras,
         msehi TYPE t006a-msehi,
         mseh3 TYPE t006a-mseh3,
       END OF ty_t006a.

* Declarando minhas tabelas internas globais, work áreas globais e variáveis globais que vão ser utilizadas no REPORT *
DATA: gt_bdcdata    TYPE STANDARD TABLE OF bdcdata,
      gt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll,
      gw_bdcdata    TYPE bdcdata.

DATA: gw_mara  TYPE ty_mara,
      gw_makt  TYPE ty_makt,
      gw_t006a TYPE ty_t006a.

DATA: gt_tvarvc TYPE STANDARD TABLE OF tvarvc,
      gw_tvarvc TYPE tvarvc.

DATA: gv_text   TYPE makt-maktx.
