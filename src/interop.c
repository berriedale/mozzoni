#include <errno.h>

/*
 * errno is a macro on most modern GNU/libc's which means that we cannot
 * Import it like other bindings from Ada
 */
int fetch_errno() { return errno; }
