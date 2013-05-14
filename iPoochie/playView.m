#import "playView.h"
#import "AppDelegate.h"

@implementation playView
@synthesize timingDate;
@synthesize left;
@synthesize right;
@synthesize item;
@synthesize chosenItem;
@synthesize itemPoint;
@synthesize currentPoint;
@synthesize previousPoint;
@synthesize acceleration;
@synthesize petXVelocity;
@synthesize petYVelocity;


/*
 * drawRect - draws the pet and item
 */
- (void)drawRect:(CGRect)rect
{
    // Grab image data if needed
    if(item == nil)
    {
        // Find which item was chose to play with,set the image and draw
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                         initWithContentsOfFile: [appDelegate gameDataPath]];
        chosenItem = [gameData objectForKey:@"chosenItem"];
        [self generateItemPoint];
        self.item = [UIImage imageNamed:chosenItem];
    }
    
    // Drawing code for toy
    [item drawAtPoint:itemPoint];
    
    // Drawing code for pet in left movement
    if(currentPoint.x<previousPoint.x)
    {
        [left drawAtPoint:currentPoint];
    }
    // Drawing code for pet in right movement
    else
    {
        [right drawAtPoint:currentPoint];
    }
    
} // End drawRect

/*
 * initWithCoder - Inits the view
 * and assigns images and points
 */
-(id) initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:(NSCoder*)coder])
    {
        // Set the frame size
        //self.frame = CGRectMake(0,20,320,390);
        
        // Set the pet images
        self.left = [UIImage imageNamed:@"walkingLeft.png"];
        self.right = [UIImage imageNamed:@"walkingRight.png"];
        
        // Set current point to center of view
        self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
                                        (left.size.width / 2.0f),
                                        (self.bounds.size.height / 2.0f) + (left.size.height / 2.0f));
        
        // Generate a random point for item
        [self generateItemPoint];
        
        // Default velocity
        petXVelocity = 0.0f;
        petYVelocity = 0.0f;
        
        timingDate = [NSDate date]; // Set the date
    }
    
    return self;
    
} // End initWithCoder

/*
 * generateItemPoint - generates random point
 * in view to draw item
 */
-(void) generateItemPoint
{
    // Generate random point to draw item
    CGFloat x = (CGFloat) (arc4random() % (int) self.bounds.size.width);
    CGFloat y = (CGFloat) (arc4random() % (int) self.bounds.size.height);
    
    self.itemPoint = CGPointMake(x,y);
    
    
    // Make sure point leaves enough space to draw item
    if(itemPoint.x < 0)
    {
        itemPoint.x = 0;
    }
    if(itemPoint.y < 0)
    {
        itemPoint.y = 0;
    }
    if(itemPoint.x > self.bounds.size.width - item.size.width)
    {
        itemPoint.x = self.bounds.size.width - item.size.width;
    }
    if(itemPoint.y > self.bounds.size.height - item.size.height)
    {
        itemPoint.y = self.bounds.size.height - item.size.height;
    }
    
    CGRect itemImageRect = CGRectMake(itemPoint.x, itemPoint.y,
                                      itemPoint.x + item.size.width,
                                      itemPoint.y + item.size.height);
    [self setNeedsDisplayInRect:itemImageRect];

    [item drawAtPoint:itemPoint];

}

/*
 * currentPoint - returns the currentPoint
 */
-(CGPoint)currentPoint
{
    return currentPoint;
    
} // End currentPoint

/* 
 * setCurrentPoint - sets the current point for the pet
 */
-(void)setCurrentPoint:(CGPoint)newPoint
{
    // Update the points
    previousPoint = currentPoint;
    currentPoint = newPoint;
    
    // Bounce the pet when it reaches edges of view
    if(currentPoint.x < 0)
    {
        currentPoint.x = 0;
        petXVelocity = -(petXVelocity / 2.0);
    }
    if(currentPoint.y < 0)
    {
        currentPoint.y = 0;
        petYVelocity = -(petYVelocity / 2.0);
    }
    if(currentPoint.x > self.bounds.size.width - left.size.width)
    {
        currentPoint.x = self.bounds.size.width - left.size.width;
        petXVelocity = -(petXVelocity / 2.0);
    }
    if(currentPoint.y > self.bounds.size.height - left.size.height)
    {
        currentPoint.y = self.bounds.size.height - left.size.height;
        petYVelocity = -(petYVelocity / 2.0);
    }
    
    CGRect currentImageRect = CGRectMake(currentPoint.x, currentPoint.y,
                                         currentPoint.x + left.size.width,
                                         currentPoint.y + left.size.height);
    CGRect previousImageRect = CGRectMake(previousPoint.x, previousPoint.y,
                                          previousPoint.x + left.size.width,
                                          currentPoint.y + left.size.width);
    [self setNeedsDisplayInRect:CGRectUnion(currentImageRect, previousImageRect)];
    
}

/*
 * update - updates the pet's current point 
 * based on movement of screen
 */
-(void)update
{
    static NSDate *lastUpdatTime;
    
    if(lastUpdatTime != nil)
    {
        NSTimeInterval secondsSinceLastDraw =
        -([lastUpdatTime timeIntervalSinceNow]);
        
        petYVelocity = petYVelocity + -(acceleration.y*secondsSinceLastDraw);
        petXVelocity = petXVelocity + acceleration.x*secondsSinceLastDraw;
        
        CGFloat xAcceleration = secondsSinceLastDraw*petXVelocity*1000;
        CGFloat yAcceleration = secondsSinceLastDraw*petYVelocity*1000;
        
        self.currentPoint = CGPointMake(self.currentPoint.x + xAcceleration, self.currentPoint.y + yAcceleration);
        
    }
    
    // Update last time with time now
    lastUpdatTime = [[NSDate alloc] init];
    
} // End update

/*
 * success - Calculates reward for success
 * and shows image of reward
 */
-(void)success
{
    // Play chime sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"chime_up" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
    NSString *direction;
    NSString *reward = @"points";
    
    // Find how much time before pet caught item
    NSNumber *timeNumber = [NSNumber numberWithDouble:
                            [[NSDate date] timeIntervalSinceDate:self.timingDate]];
    int time = [timeNumber intValue];
    
    int change = 1; // change for level
    
    // Change increases when time > 10
    if(time > 10)
    {
        change = 3;
    }
    
    // Grab points from plist through app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *gameData = [[NSMutableDictionary alloc]
                                     initWithContentsOfFile: [appDelegate gameDataPath]];
    
    // Update the energry level
    NSNumber *energyLevel = [gameData objectForKey:@"energy"];
    int energyPercentage = [energyLevel intValue] - change;
    
    // Make sure doen't go below 0
    if(energyPercentage < 0)
    {
        energyPercentage = 0;
    }
    
    [gameData setObject:[NSNumber numberWithInt:energyPercentage]
                 forKey:@"energy"];
    
    // Update the happiness level
    NSNumber *happinessLevel = [gameData objectForKey:@"happiness"];
    int happinessPercentage = [happinessLevel intValue];
    
    // if energy greater than 10 increase happiness
    if(energyPercentage > 15)
    {
        direction = @"up";
        happinessPercentage += change;
    }
    else
    {
        direction = @"down";
        happinessPercentage -= change;
    }
    
    // Make sure it doesn't go above 100 or below 0
    if(happinessPercentage > 100)
    {
        happinessPercentage = 100;
    }
    if(happinessPercentage < 0)
    {
        happinessPercentage = 0;
    }

    [gameData setObject:[NSNumber numberWithInt:happinessPercentage]
                 forKey:@"happiness"];
    
    // Update health by change + or - , if possible
    NSNumber *healthLevel = [gameData objectForKey:@"health"];
    
    if ([direction isEqual:@"up"] && ([healthLevel intValue] + change) <= 100)
    {
        [gameData setObject:[NSNumber numberWithInt:([healthLevel intValue] + change)]
                     forKey:@"health"];
    }
    if ([direction isEqual:@"down"] && ([healthLevel intValue] - change) >= 0)
    {
        [gameData setObject:[NSNumber numberWithInt:([healthLevel intValue] - change)]
                     forKey:@"health"];
    }
    
    //NSLog(@"Time is %i", time);
    // NSLog(@"Energy was: %@ now: %i", energyLevel, energyPercentage);
    // NSLog(@"Happiness was: %@ now: %i", happinessLevel, happinessPercentage);
    //NSLog(@"Health was: %@ change: %i direction %@", healthLevel, change, direction);
    
    NSNumber *points = [gameData objectForKey:@"points"];

    // Number to increment points
    int pointsInt = 0;
    
    // Choose number of points based on time and item played with
    if(time > 10)
    {
        if([chosenItem isEqual:@"mouse.png"])
        {
            pointsInt = 5;
        }
        else
        {
            pointsInt = 1;
        }
    }
    else if(time <= 10 && time > 8)
    {
        if([chosenItem isEqual:@"mouse.png"])
        {
            pointsInt = 10;
        }
        else if([chosenItem isEqual:@"ducky.png"]
                || [chosenItem isEqual:@"frisbee.png"])
        {
            pointsInt = 4;
        }
        else if([chosenItem isEqual:@"ball.png"]
                || [chosenItem isEqual:@"ball2.png"]
                || [chosenItem isEqual:@"ball3.png"])
        {
            pointsInt = 3;
        }
        else
        {
            pointsInt = 2;
        }
    }
    else if(time <= 8 && time > 5)
    {
        if([chosenItem isEqual:@"mouse.png"])
        {
            pointsInt = 15;
        }
        else if([chosenItem isEqual:@"ducky.png"]
                || [chosenItem isEqual:@"frisbee.png"])
        {
            pointsInt = 5;
        }
        else if([chosenItem isEqual:@"ball.png"]
                || [chosenItem isEqual:@"ball2.png"]
                || [chosenItem isEqual:@"ball3.png"])
        {
            pointsInt = 5;
        }
        else
        {
            pointsInt = 3;
        }
    }
    else if(time <= 5 && time > 3)
    {
        if([chosenItem isEqual:@"mouse.png"])
        {
            pointsInt = 15;
        }
        else if([chosenItem isEqual:@"ducky.png"]
                || [chosenItem isEqual:@"frisbee.png"])
        {
            pointsInt = 10;
        }
        else if([chosenItem isEqual:@"ball.png"]
                || [chosenItem isEqual:@"ball2.png"]
                || [chosenItem isEqual:@"ball3.png"])
        {
            pointsInt = 5;
        }
        else
        {
            pointsInt = 4;
        }
    }
    else if(time <= 3)
    {
        if([chosenItem isEqual:@"mouse.png"])
        {
            pointsInt = 20;
        }
        else if([chosenItem isEqual:@"ducky.png"]
                || [chosenItem isEqual:@"frisbee.png"])
        {
            pointsInt = 15;
        }
        else if([chosenItem isEqual:@"ball.png"]
                || [chosenItem isEqual:@"ball2.png"]
                || [chosenItem isEqual:@"ball3.png"])
        {
            // If possible give boost of energy 
            int boost = (arc4random() % (20 - 10)) + 11;
            
            // Get the energry level with boost
            energyLevel = [gameData objectForKey:@"energy"];
            energyPercentage = [energyLevel intValue] + boost;
            
            // Make sure doen't go above 100
            if(energyPercentage > 100)
            {
                energyPercentage = 100;
                pointsInt = 10;
            }
            else
            {
                reward = @"energy"; // Boost of energy possible
                [gameData setObject:[NSNumber numberWithInt:energyPercentage]
                             forKey:@"energy"];
                self.left = [UIImage imageNamed:@"energyBoost.png"];
                self.right = [UIImage imageNamed:@"energyBoost.png"];

            }
        }
        else
        {
            pointsInt = 5;
        }
    }
        
    if([reward isEqual:@"points"])
    {
        switch(pointsInt)
        {
            case 1:
                self.left = [UIImage imageNamed:@"1points.png"];
                self.right = [UIImage imageNamed:@"1points.png"];
                break;
            case 2:
                self.left = [UIImage imageNamed:@"2points.png"];
                self.right = [UIImage imageNamed:@"2points.png"];
                break;
            case 3:
                self.left = [UIImage imageNamed:@"3points.png"];
                self.right = [UIImage imageNamed:@"3points.png"];
                break;
            case 4:
                self.left = [UIImage imageNamed:@"4points.png"];
                self.right = [UIImage imageNamed:@"4points.png"];
                break;
            case 5:
                self.left = [UIImage imageNamed:@"5points.png"];
                self.right = [UIImage imageNamed:@"5points.png"];
                break;
            case 10:
                self.left = [UIImage imageNamed:@"10points.png"];
                self.right = [UIImage imageNamed:@"10points.png"];
                break;
            case 15:
                self.left = [UIImage imageNamed:@"15points.png"];
                self.right = [UIImage imageNamed:@"15points.png"];
                break;
            case 20 :
                self.left = [UIImage imageNamed:@"20points.png"];
                self.right = [UIImage imageNamed:@"20points.png"];
                break;
        }
    
        // Increment points
        points = [NSNumber numberWithInt: ([points intValue] + pointsInt)];
        [gameData setObject:points
                     forKey:@"points"];
    }
    
    // Update all changes
    [gameData writeToFile:[appDelegate gameDataPath] atomically:NO];
    
    // Reset the timing
    timingDate = [NSDate date];
    
    // Change the location of the item
    [self generateItemPoint];
    
    // After timer revert images back to pet
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                   selector:@selector(clearSuccess:)
                                   userInfo:nil repeats:NO];
    
} // End success

/*
 * clearSuccess - Reverts back to left 
 * and right pet images from reward image
 */
-(void)clearSuccess:(NSTimer*)inTimer
{
    [inTimer invalidate];
    inTimer = nil;
    
    self.left = [UIImage imageNamed:@"walkingLeft.png"];
    self.right = [UIImage imageNamed:@"walkingRight.png"];
    
} // End success

/*
 * touchesBegan: withEvent - On touch 
 * check for success
 * success being when both pet and
 * item are within range of touch
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Find location of touch
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat range = 70;     // Define the range
    BOOL itemInRange = NO;  // YES if item is in range of touch
    BOOL petInRange = NO;   // YES if pet is in range of touch
    
    // Check to see if item is in range of touch
    if(itemPoint.x < touchPoint.x + range &&
       itemPoint.x > touchPoint.x - range &&
       itemPoint.y < touchPoint.y + range &&
       itemPoint.y > touchPoint.y - range)
    {
        itemInRange = YES;
    }
    
    // Check to see if pet is in range of touch
    if(currentPoint.x < touchPoint.x + range &&
       currentPoint.x > touchPoint.x - range &&
       currentPoint.y < touchPoint.y + range &&
       currentPoint.y > touchPoint.y - range)
    {
        petInRange = YES;
    }
    
    // Success! Item is caught!
    if(itemInRange == YES && petInRange == YES)
    {
        [self success];
    }
    
} // End touchesBegan: withEvent

@end
