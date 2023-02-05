-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC ##Sobre o conjunto de dados
-- MAGIC 
-- MAGIC ###Quais fatores afetam os preços dos computadores portáteis?
-- MAGIC * Vários fatores diferentes podem afetar os preços dos laptops. Esses fatores incluem a marca do computador e o número de opções e complementos incluídos no pacote do computador. Além disso, a quantidade de memória e a velocidade do processador também podem afetar o preço. Embora menos comum, alguns consumidores gastam dinheiro adicional para comprar um computador com base na “aparência” geral e no design do sistema.
-- MAGIC * Em muitos casos, os computadores de marca são mais caros do que as versões genéricas. Esse aumento de preço geralmente tem mais a ver com o reconhecimento do nome do que com qualquer superioridade real do produto. Uma grande diferença entre os sistemas de marca e genéricos é que, na maioria dos casos, os computadores de marca oferecem melhores garantias do que as versões genéricas. Ter a opção de devolver um computador com defeito costuma ser um incentivo suficiente para encorajar muitos consumidores a gastar mais dinheiro.
-- MAGIC * A funcionalidade é um fator importante na determinação dos preços dos laptops. Um computador com mais memória geralmente funciona melhor por mais tempo do que um computador com menos memória. Além disso, o espaço no disco rígido também é crucial, e o tamanho do disco rígido geralmente afeta os preços. Muitos consumidores também podem procurar drivers de vídeo digital e outros tipos de dispositivos de gravação que possam afetar os preços dos laptops.
-- MAGIC * A maioria dos computadores vem com algum software pré-instalado. Na maioria dos casos, quanto mais software for instalado em um computador, mais caro ele será. Isso é especialmente verdadeiro se os programas instalados forem de editores de software bem estabelecidos e reconhecíveis. Aqueles que estão pensando em comprar um novo laptop devem estar cientes de que muitos dos programas pré-instalados podem ser apenas versões de teste e expirarão dentro de um determinado período de tempo. Para manter os programas, será necessário adquirir um código e, em seguida, fazer o download de uma versão permanente do software.
-- MAGIC * Muitos consumidores que estão comprando um novo computador estão comprando um pacote completo. Além do próprio computador, esses sistemas normalmente incluem um monitor, teclado e mouse. Alguns pacotes podem até incluir uma impressora ou câmera digital. O número de extras incluídos em um pacote de computador geralmente afeta os preços dos laptops.
-- MAGIC * Alguns líderes da indústria de fabricação de computadores tornam um ponto de venda oferecer computadores em estilo elegante e em uma variedade de cores. Eles também podem oferecer um design de sistema incomum ou contemporâneo. Embora isso seja menos importante para muitos consumidores, para aqueles que valorizam a “aparência”, esse tipo de sistema pode valer o custo extra.
-- MAGIC 
-- MAGIC ###De onde eu consegui esses dados?
-- MAGIC * Extraiu esses dados de flipkart.com
-- MAGIC usou uma ferramenta automatizada de extensão da Web do Chrome chamada Instant Data Scrapper
-- MAGIC recomendo que você use esta bela ferramenta para obter os dados de qualquer lugar na web. é muito fácil de usar, nenhum conhecimento de codificação é necessário.
-- MAGIC 
-- MAGIC ###O que você pode fazer?
-- MAGIC * Visualize esses dados e prepare gráficos de alta qualidade o máximo que puder.
-- MAGIC * Construir um modelo para prever o preço
-- MAGIC * Análise descritiva, prescritiva, diagnóstica e preditiva
-- MAGIC 
-- MAGIC * Fonte de dados: https://www.kaggle.com/datasets/kuchhbhi/latest-laptop-price-list?resource=download

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #Análise Descritiva (SQL)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### ETL

-- COMMAND ----------

SELECT * FROM notebooks_vendidos -- visualizando dados

-- COMMAND ----------

alter view vw_notebooks_vendidos
as
select *, (ultimo_preco * 0.063) as preco_atual_brl, -- convertendo de rupias indianas para Real
(preco_antigo * 0.063) as preco_anterior_brl,
(desconto/100) as desconto_perct -- incluindo coluna com o desconto em percentual
from notebooks_vendidos

-- COMMAND ----------

select * from vw_notebooks_vendidos

-- COMMAND ----------

-- MAGIC %md ### Média de preço das marcas

-- COMMAND ----------

select
case when marca = 'lenovo' then 'Lenovo' -- Lenovo aparece 2x: Com 'L' e 'l'
     else marca 
end as marca_ajustada,
avg(preco_atual_brl) as media_preco_atual
from vw_notebooks_vendidos
group by
case when marca = 'lenovo' then 'Lenovo' -- Lenovo aparece 2x: Com 'L' e 'l'
     else marca 
end
order by 2 desc
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md ### Quais são os processadores mais vendidos?

-- COMMAND ----------

SELECT processador_nome, COUNT(*) as vendas
FROM vw_notebooks_vendidos
GROUP BY processador_nome
ORDER BY vendas DESC
LIMIT 10;


-- COMMAND ----------

-- MAGIC %md ### Qual a média de preço dos computadores com 'Core i5'?

-- COMMAND ----------

SELECT AVG(preco_atual_brl)
FROM vw_notebooks_vendidos
WHERE processador_nome = 'Core i5';

-- COMMAND ----------

-- MAGIC %md ### Marcas para ficar de olho: Qual o ranking das marcas que oferecem mais descontos?

-- COMMAND ----------

SELECT marca, AVG(desconto_perct) as media_desconto
FROM vw_notebooks_vendidos
GROUP BY marca
ORDER BY media_desconto DESC
LIMIT 5;

-- COMMAND ----------


