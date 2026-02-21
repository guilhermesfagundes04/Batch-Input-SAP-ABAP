*  Faço um SELECTION-SCREEN para por na tela a minha seleção (nesse casso PARAMETER) que vai ser utilizada para filtrar os dados que vão ser pesquisados. *
SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_matnr TYPE mara-matnr OBLIGATORY.

SELECTION-SCREEN END OF BLOCK bc01.
