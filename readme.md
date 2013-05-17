## DBBasementController
`DBBasementController` is a configurable and easy to use slide out menu.

### Adding DBBasementController
You can add it to your project by copying the `DBBasementController` directory into your project.

You can also add it using Cocoapods:

    pod "DBBasementController"

`DBBasementController` requires iOS 6.0 or greater.

### Using DBBasementController
To use it initialize with both a menu and content view controller:

    UIViewController *menuViewController = ...;
    UIViewController *contentViewController = ...;
    DBBasementController = *basementController = [[DBBasementController alloc] initWithMenuViewController:menuViewController contentViewController:contentViewController];

Your view controllers can access the menu via the `basementController` property.

    #import "DBBasementController.h"
    ...
    [self.basementController openMenuAnimated:YES];


### Customizing DBBasementController
You can customize the appearance and behavior of the `DBBasementController` by passing a `DBBasementOptions` instance during initialization or by setting the `options` property at any point.

`DBBasementOptions` allows you to customize the all of the animations timings and options, as well aspects of the appearance including the sahdow and corner radius of the menu and content view controllers.

`DBBasementOptions` also allows you to set a `CGAffineTransform` that will be applied to the `menuViewController`'s view when it is closed. This transform is animated as the menu is opened/closed.


### Callbacks
`DBBasementController` provides a series of callbacks for your menu and content view controllers. Provide an implementation of any of these methods in your content or menu view controllers to receive the callbacks:
    
    - (void)menuWillOpen;
    - (void)menuDidOpen;
    - (void)menuWillClose;
    - (void)menuDidClose;

    - (void)menuIsAnimatingOpen;
    - (void)menuIsAnimatingClosed;

    // This is called as the menu is dragged, percentOpen will be between 0 and 1
    - (void)menuDidMove:(CGFloat)percentOpen; 

### Sample Application
The sample application includes a simple implementation of the DBBasementController as well as controls to adjust many of the `DBBasementOptions` properties.
