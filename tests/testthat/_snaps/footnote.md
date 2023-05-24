# generating numbered footnote refs with default settings

    Code
      footnote_options()$ref(1L)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 1     TRUE  TRUE       
      

---

    Code
      footnote_options()$ref(c(1L, 3L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 1     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 3     TRUE  TRUE       
      

# generating footnote refs with common settings

    Code
      footnote_options(ref = "1")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 1     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 2     TRUE  TRUE       
      

---

    Code
      footnote_options(ref = "a")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 a     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 b     TRUE  TRUE       
      

---

    Code
      footnote_options(ref = "A")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 A     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 B     TRUE  TRUE       
      

---

    Code
      footnote_options(ref = "i")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 i     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 ii    TRUE  TRUE       
      

---

    Code
      footnote_options(ref = "I")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 I     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 II    TRUE  TRUE       
      

---

    Code
      footnote_options(ref = "*")$ref(c(1L, 2L))
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 *     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 **    TRUE  TRUE       
      

# generating footnote refs with prefix and suffix

    Code
      opt$ref(1L, "header", TRUE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 (1)   TRUE  TRUE       
      

---

    Code
      opt$ref(1L, "header", FALSE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 (1)   TRUE  TRUE       
      

---

    Code
      opt$ref(1L, "body", TRUE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 (1)   TRUE  TRUE       
      

---

    Code
      opt$ref(1L, "body", FALSE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 (1)   TRUE  TRUE       
      

# generating footnote refs with callbacks

    Code
      opt$ref(c(1L, 2L), "header", TRUE)
    Output
      [[1]]
      # A tibble: 3 x 3
        txt   Str   Space
        <chr> <lgl> <lgl>
      1 "1:"  TRUE  FALSE
      2 " "   FALSE TRUE 
      3 ":"   TRUE  FALSE
      
      [[2]]
      # A tibble: 3 x 3
        txt   Str   Space
        <chr> <lgl> <lgl>
      1 "2:"  TRUE  FALSE
      2 " "   FALSE TRUE 
      3 ":"   TRUE  FALSE
      

---

    Code
      opt$ref(c(1L, 2L), "header", FALSE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 1     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 2     TRUE  TRUE       
      

---

    Code
      opt$ref(c(1L, 2L), "body", TRUE)
    Output
      [[1]]
      # A tibble: 3 x 3
        txt   Str   Space
        <chr> <lgl> <lgl>
      1 "a:"  TRUE  FALSE
      2 " "   FALSE TRUE 
      3 ":"   TRUE  FALSE
      
      [[2]]
      # A tibble: 3 x 3
        txt   Str   Space
        <chr> <lgl> <lgl>
      1 "b:"  TRUE  FALSE
      2 " "   FALSE TRUE 
      3 ":"   TRUE  FALSE
      

---

    Code
      opt$ref(c(1L, 2L), "body", FALSE)
    Output
      [[1]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 a     TRUE  TRUE       
      
      [[2]]
      # A tibble: 1 x 3
        txt   Str   Superscript
        <chr> <lgl> <lgl>      
      1 b     TRUE  TRUE       
      

