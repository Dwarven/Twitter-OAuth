# Twitter-OAuth
iOS Twitter OAuth
How to use 
---
add folder "TwitterOAuthViewController" to your project,import "TwitterOAuthViewController.h"

```obj-c
TwitterOAuthViewController * twitterOAuthVC = [[TwitterOAuthViewController alloc] initWithCompletion:^(BOOL succeeded, id object) {
    if (succeeded && object) {
        NSLog(@"%@",object);
        //do something
    }
}];
UINavigationController * navC = [[UINavigationController alloc] initWithRootViewController:twitterOAuthVC];
[self presentViewController:navC animated:YES completion:NULL];
```
**Enjoy**
