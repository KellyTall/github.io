library(rvest)
library(tidyverse)
library(stringr)
library(tidyr)
library(lubridate)



html_1 <-  read_html("https://en.wikipedia.org/w/index.php?title=2011_Egyptian_revolution&action=history&dir=prev&limit=5000")

user_name_html_1 <- html_1%>% 
  html_elements("bdi") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(user_name=value)


date_html_1 <- html_1 %>% 
  html_elements(".mw-changeslist-date") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(date_time = value)

edit_type_1 <- html_1 %>% 
  html_elements("span.history-size.mw-diff-bytes") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(bytes=value)

html_2 <-  read_html("https://en.wikipedia.org/w/index.php?title=2011_Egyptian_revolution&action=history&limit=5000")

user_name_html_2 <- html_2%>% 
  html_elements("bdi") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(user_name=value)


date_html_2 <- html_2 %>% 
  html_elements(".mw-changeslist-date") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(date_time = value)

edit_type_2 <- html_2 %>% 
  html_elements("span.history-size.mw-diff-bytes") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  rename(bytes=value)
  
  
first_set <- cbind(user_name_html_1, date_html_1, edit_type_1) %>% 
  as_tibble()  

second_set <- cbind(user_name_html_2, date_html_2, edit_type_2) %>% 
  as_tibble()  


all_set <- rbind(first_set, second_set) %>% 
  distinct() %>% 
  separate_wider_delim(date_time, delim=", ", names=c("time", "date")) %>% 
  # mutate(time=hm(time),
  #        time = as.character(time)) %>% 
  unite(date_time, c(date,time), sep = ", ") %>% 
  mutate(date_time = dmy_hm(date_time)) %>% 
  mutate(byte_size = str_remove_all(bytes, " bytes"),
         byte_size= as.numeric(byte_size))

  
  
View(all_set)

  