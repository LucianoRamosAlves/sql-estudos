# 📚 Guia Completo de JOINs no MySQL

## 🗂️ Índice dos Estudos

### Básico
| # | Arquivo | Conteúdo |
|---|---------|----------|
| 1 | [01_inner_join.sql](./01_inner_join.sql) | **INNER JOIN** - Junção interna (só o que existe em ambas) |
| 2 | [02_left_join.sql](./02_left_join.sql) | **LEFT JOIN** - Tudo da esquerda + correspondências da direita |
| 3 | [03_right_join.sql](./03_right_join.sql) | **RIGHT JOIN** - Tudo da direita + correspondências da esquerda |

### Avançado
| # | Arquivo | Conteúdo |
|---|---------|----------|
| 4 | [04_full_outer_join.sql](./04_full_outer_join.sql) | **FULL OUTER JOIN** - União completa (simulado com UNION) |
| 5 | [05_cross_join.sql](./05_cross_join.sql) | **CROSS JOIN** - Produto cartesiano (todas combinações) |
| 6 | [06_self_join.sql](./06_self_join.sql) | **SELF JOIN** - Junção com a própria tabela (hierarquias) |

### Técnicas Avançadas
| # | Arquivo | Conteúdo |
|---|---------|----------|
| 7 | [07_multiplos_joins.sql](./07_multiplos_joins.sql) | **Múltiplos JOINs** - 3, 4, 5+ tabelas juntas |
| 8 | [08_using_vs_on.sql](./08_using_vs_on.sql) | **USING vs ON** - Diferenças e quando usar cada um |
| 9 | [09_dicas_praticas.sql](./09_dicas_praticas.sql) | **Dicas Práticas** - Erros comuns, boas práticas, performance |

---

## 🎯 Resumo Rápido

| JOIN | Descrição | Resultado |
|------|-----------|-----------|
| **INNER JOIN** | Só registros que existem nas duas tabelas | ![A∩B](https://via.placeholder.com/20/4CAF50/000000?text=A∩B) |
| **LEFT JOIN** | Todos da esquerda + correspondências da direita | ![A+B](https://via.placeholder.com/20/2196F3/000000?text=A+B) |
| **RIGHT JOIN** | Todos da direita + correspondências da esquerda | ![B+A](https://via.placeholder.com/20/FF9800/000000?text=B+A) |
| **FULL JOIN** | Todos de ambas as tabelas (simulado) | ![A∪B](https://via.placeholder.com/20/9C27B0/000000?text=A∪B) |
| **CROSS JOIN** | Todas combinações possíveis | ![A×B](https://via.placeholder.com/20/F44336/000000?text=A×B) |
| **SELF JOIN** | Tabela com ela mesma | ![Hierarquia](https://via.placeholder.com/20/607D8B/000000?text=Hier) |

## 🚀 Como usar

1. Abra cada arquivo SQL na ordem numérica
2. Cada arquivo é **independente** e cria seu próprio banco de dados
3. Execute o script completo ou partes dele no MySQL
4. Leia os comentários - eles explicam cada linha!

## ⚠️ Importante

- Cada script cria o banco `estudos_joins` e recria as tabelas
- Use `DROP DATABASE IF EXISTS estudos_joins` no final se quiser limpar
- Todos os exemplos são comentados em português
- Os dados de exemplo são consistentes entre os arquivos
