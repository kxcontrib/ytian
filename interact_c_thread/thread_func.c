#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>

#include"k.h"

#define handle_error_en(en, msg) \
  do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

#define handle_error(msg) \
  do { perror(msg); exit(EXIT_FAILURE); } while (0)

struct thread_info {  
  K       arg;      
};

static void * thread_start(void *arg)
{
  struct thread_info *tinfo = (struct thread_info *)arg;
  printf("within thread %i\n", tinfo->arg->i);
  K* res = malloc(sizeof(K));
  *res = k(0, "1+", r1(tinfo->arg), 0); 
  return res;
}


K thread_func(K x)
{
  int s;
  pthread_t thread_id;
  struct thread_info* tinfo;
  pthread_attr_t attr;
  int stack_size = 2 << 16;
  void *res;

  s = pthread_attr_init(&attr);
  if (s != 0)
    handle_error_en(s, "pthread_attr_init");

  s = pthread_attr_setstacksize(&attr, stack_size);
  if (s != 0)
    handle_error_en(s, "pthread_attr_setstacksize");

  tinfo = malloc(sizeof(struct thread_info));
  //tinfo->arg = x->i;
  tinfo->arg = x;
  if (tinfo == NULL)    handle_error("calloc");

  s = pthread_create(&thread_id, &attr,
                     &thread_start, tinfo);
  if (s != 0)
    handle_error_en(s, "pthread_create");

  s = pthread_attr_destroy(&attr);
  if (s != 0)
    handle_error_en(s, "pthread_attr_destroy");

  /* Now join with each thread, and display its returned value */
  s = pthread_join(thread_id, &res);
  if (s != 0)
    handle_error_en(s, "pthread_join");

  printf("Joined thread, returned value was %i\n", (*(K*)res)->i);
  K kres = *(K*)res;

  free(res);      /* Free memory allocated by thread */
  free(tinfo);

  return kres;
}
