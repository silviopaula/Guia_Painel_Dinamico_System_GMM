********************************************************************************
* Paper: Economic Growth Channels From Human Capital: A Dynamic Panel Analysis for Brazil

********************************************************************************
*Instalar pacotes
*ssc install xtabond2
*net install st0085_2.pkg
*set more off, perm
*ssc install asdoc

*Limpar tudo
clear all

*Abrir a base
use "D:\OneDrive\Documentos\BASE_CH.dta", clear

*Declarar painel
xtset id Ano

*Escolhendo pasta para saídas das tabelas
cd "D:\OneDrive\Documentos\RESULTADOS"

* Gerar global das covariadas
global Cov ln_Gec popgr D_Crisis Trend 

*----------------------------------------------------------------------------------
*estatisticas descritivas
asdoc sum lnY_L Tx_K_L popgr ln_Gec ln_HC Tx_HC ln_HC_bh Tx_HC_ah ln_HC_ah Tx_HC_bh D_Crisis n_prof_bh n_prof_ah, replace title(Estatisticas Descritivas) save(Descritivas.rtf) fs(10) dec(3) tzok


*-------------------------------------------------------------------------------

*----------------------*
// REGRESSÕES COM PCA //
*----------------------*

* Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC) iv($Cov n_prof_ah) twostep robust pca components (21)
estimates store reg1

* Log natural
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC) twostep robust pca components (21)
estimates store reg2

* Log natural e Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC) iv($Cov ln_HC n_prof_ah) twostep robust pca components (20)
estimates store reg3

* Taxa crescimento Educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh) iv($Cov n_prof_bh) twostep robust pca components (21) 
estimates store reg4

* Log Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC_ah) twostep robust pca components (21) 
estimates store reg5

* Log Educação Avanççada & taxa educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh) iv($Cov  ln_HC_ah n_prof_bh) twostep robust pca components (20) 
estimates store reg6

* Taxa crescimento Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah) iv($Cov n_prof_ah) twostep robust pca components (21)
estimates store reg7

* Log Educação Basica  
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC_bh) twostep robust pca components (21)
estimates store reg8

* Log Educação Basica & taxa educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah) iv($Cov  ln_HC_bh n_prof_ah) twostep robust pca components (20) 
estimates store reg9

*Gerar tabela de resultados
esttab reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 using "RESULTADOS_PCA.rtf", b(%12.2f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace
*-------------------------------------------------------------------------------

*---------------------------------------*
// REGRESSÕES COM LAG LIMIT & COLLAPSE //
*---------------------------------------*

* Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, lag(2 6) collapse) iv($Cov n_prof_ah) twostep robust
estimates store reg1LC

* Log natural
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC $Cov, gmm(L.lnY_L Tx_K_L, lag(2 10) collapse) iv($Cov ln_HC) twostep robust
estimates store reg2LC

* Log natural e Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, lag(2 6) collapse) iv($Cov ln_HC n_prof_ah) twostep robust
estimates store reg3LC

* Taxa crescimento Educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, lag(2 6) collapse) iv($Cov n_prof_bh) twostep robust
estimates store reg4LC

* Log Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah $Cov, gmm(L.lnY_L Tx_K_L, lag(2 10) collapse) iv($Cov ln_HC_ah) twostep robust
estimates store reg5LC

* Log Educação Avanççada & taxa educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, lag(2 6) collapse) iv($Cov  ln_HC_ah n_prof_bh) twostep robust
estimates store reg6LC

* Taxa crescimento Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, lag(2 6) collapse) iv($Cov n_prof_ah) twostep robust
estimates store reg7LC

* Log Educação Basica  
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh $Cov, gmm(L.lnY_L Tx_K_L, lag(2 10) collapse) iv($Cov ln_HC_bh) twostep robust
estimates store reg8LC

* Log Educação Basica & taxa educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, lag(2 6) collapse) iv($Cov  ln_HC_bh n_prof_ah) twostep robust 
estimates store reg9LC

*Gerar tabela de resultados
esttab reg1LC reg2LC reg3LC reg4LC reg5LC reg6LC reg7LC reg8LC reg9LC using "RESULTADOS_LAG_COLLAPSE.rtf", b(%12.2f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace
*-------------------------------------------------------------------------------

*----------------------------*
// REGRESSÕES COM LAG LIMIT //
*----------------------------*

* Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, lag(2 2)) iv($Cov n_prof_ah) twostep robust
estimates store reg1L

* Log natural
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC $Cov, gmm(L.lnY_L Tx_K_L, lag(2 2)) iv($Cov ln_HC) twostep robust
estimates store reg2L

* Log natural e Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, lag(2 2)) iv($Cov ln_HC n_prof_ah) twostep robust
estimates store reg3L

* Taxa crescimento Educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, lag(2 2)) iv($Cov n_prof_bh) twostep robust
estimates store reg4L

* Log Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah $Cov, gmm(L.lnY_L Tx_K_L, lag(2 2)) iv($Cov ln_HC_ah) twostep robust
estimates store reg5L

* Log Educação Avanççada & taxa educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, lag(2 2)) iv($Cov  ln_HC_ah n_prof_bh) twostep robust
estimates store reg6L

* Taxa crescimento Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, lag(2 2)) iv($Cov n_prof_ah) twostep robust
estimates store reg7L

* Log Educação Basica  
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh $Cov, gmm(L.lnY_L Tx_K_L, lag(2 2)) iv($Cov ln_HC_bh) twostep robust
estimates store reg8L

* Log Educação Basica & taxa educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, lag(2 2)) iv($Cov  ln_HC_bh n_prof_ah) twostep robust 
estimates store reg9L

*Gerar tabela de resultados
esttab reg1L reg2L reg3L reg4L reg5L reg6L reg7L reg8L reg9L using "RESULTADOS_LAG.rtf", b(%12.2f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace

*-------------------------------------------------------------------------------

*---------------------------*
// REGRESSÕES COM COLLAPSE //
*---------------------------*

* Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, collapse) iv($Cov n_prof_ah) twostep robust
estimates store reg1C

* Log natural
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC $Cov, gmm(L.lnY_L Tx_K_L, collapse) iv($Cov ln_HC) twostep robust
estimates store reg2C

* Log natural e Taxa de de crescimento
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC, collapse) iv($Cov ln_HC n_prof_ah) twostep robust
estimates store reg3C

* Taxa crescimento Educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, collapse) iv($Cov n_prof_bh) twostep robust
estimates store reg4C

* Log Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah $Cov, gmm(L.lnY_L Tx_K_L, collapse) iv($Cov ln_HC_ah) twostep robust
estimates store reg5C

* Log Educação Avanççada & taxa educação Basica 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_ah Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh, collapse) iv($Cov  ln_HC_ah n_prof_bh) twostep robust
estimates store reg6C

* Taxa crescimento Educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, collapse) iv($Cov n_prof_ah) twostep robust
estimates store reg7C

* Log Educação Basica  
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh $Cov, gmm(L.lnY_L Tx_K_L, collapse) iv($Cov ln_HC_bh) twostep robust
estimates store reg8C

* Log Educação Basica & taxa educação Avançada 
xtabond2 DlnY_L L.lnY_L Tx_K_L ln_HC_bh Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah, collapse) iv($Cov  ln_HC_bh n_prof_ah) twostep robust 
estimates store reg9C

*Gerar tabela de resultados
esttab reg1C reg2C reg3C reg4C reg5C reg6C reg7C reg8C reg9C using "RESULTADOS_COLLAPSE.rtf", b(%12.2f) se(2) star(* 0.10 ** 0.05 *** 0.01 ) scalars(sargan sarganp hansen hansenp ar1 ar1p ar2 ar2p j) replace

*-------------------------------------------------------------------------------

*---------------------------*
// EFEITOS DE LONGO PRAZO //
*---------------------------*
* Conforme exposto nas equações 21 a 23, elas podem ser escritas como as equações 24 a 26, e utilizamos essa notação para calcular os efeitos de longo prazo.

* Taxa de de crescimento
xtabond2 lnY_L L.lnY_L Tx_K_L Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC) iv($Cov n_prof_ah) twostep robust pca components (21)
*Exportar efeito LP
asdoc nlcom _b[Tx_HC] / (1 - _b[L.lnY_L]), replace title(Tx_HC) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log natural
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC) twostep robust pca components (21)
*Exportar efeito LP
asdoc nlcom _b[ln_HC] / (1 - _b[L.lnY_L]), append title(ln_HC) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log natural e Taxa de de crescimento
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC Tx_HC $Cov, gmm(L.lnY_L Tx_K_L Tx_HC) iv($Cov ln_HC n_prof_ah) twostep robust pca components (20)
*Exportar efeito LP
asdoc nlcom _b[ln_HC] / (1 - _b[L.lnY_L]), append title(ln_HC & Tx_HC) save(Efeito_LP.rtf) fs(10) dec(3) tzok
asdoc nlcom _b[Tx_HC] / (1 - _b[L.lnY_L]), append title(ln_HC & Tx_HC) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Taxa crescimento Educação Basica 
xtabond2 lnY_L L.lnY_L Tx_K_L Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh) iv($Cov n_prof_bh) twostep robust pca components (21) 
*Exportar efeito LP
asdoc nlcom _b[Tx_HC_bh] / (1 - _b[L.lnY_L]), append title(Tx_HC_bh) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log Educação Avançada 
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC_ah $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC_ah) twostep robust pca components (21) 
*Exportar efeito LP
asdoc nlcom _b[ln_HC_ah] / (1 - _b[L.lnY_L]), append title(Tx_HC_bh) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log Educação Avanççada & taxa educação Basica 
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC_ah Tx_HC_bh $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_bh) iv($Cov  ln_HC_ah n_prof_bh) twostep robust pca components (20) 
*Exportar efeito LP
asdoc nlcom _b[ln_HC_ah] / (1 - _b[L.lnY_L]), append title(ln_HC_ah & Tx_HC_bh) save(Efeito_LP.rtf) fs(10) dec(3) tzok
asdoc nlcom _b[Tx_HC_bh] / (1 - _b[L.lnY_L]), append title(ln_HC_ah & Tx_HC_bh) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Taxa crescimento Educação Avançada 
xtabond2 lnY_L L.lnY_L Tx_K_L Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah) iv($Cov n_prof_ah) twostep robust pca components (21)
*Exportar efeito LP
asdoc nlcom _b[Tx_HC_ah] / (1 - _b[L.lnY_L]), append title(Tx_HC_ah) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log Educação Basica  
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC_bh $Cov, gmm(L.lnY_L Tx_K_L) iv($Cov ln_HC_bh) twostep robust pca components (21)
*Exportar efeito LP
asdoc nlcom _b[ln_HC_bh] / (1 - _b[L.lnY_L]), append title(ln_HC_bh) save(Efeito_LP.rtf) fs(10) dec(3) tzok

* Log Educação Basica & taxa educação Avançada 
xtabond2 lnY_L L.lnY_L Tx_K_L ln_HC_bh Tx_HC_ah $Cov, gmm(L.lnY_L Tx_K_L Tx_HC_ah) iv($Cov  ln_HC_bh n_prof_ah) twostep robust pca components (20) 
*Exportar efeito LP
asdoc nlcom _b[ln_HC_bh] / (1 - _b[L.lnY_L]), append title(ln_HC_bh & Tx_HC_ah) save(Efeito_LP.rtf) fs(10) dec(3) tzok
asdoc nlcom _b[Tx_HC_ah] / (1 - _b[L.lnY_L]), append title(ln_HC_bh & Tx_HC_ah) save(Efeito_LP.rtf) fs(10) dec(3) tzok

*-------------------------------------------------------------------------------


