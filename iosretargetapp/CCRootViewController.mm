#import "CCRootViewController.h"

class CPPClass
{
public:
	void CPPFunction(const char *);
};

void CPPClass::CPPFunction(const char *arg0)
{
	// This for loop makes this function long enough to validate MSHookFunction
	for (int i = 0; i < 66; i++)
	{
		//u_int32_t randomNumber;
		//if (i % 3 == 0) randomNumber = arc4random_uniform(i);
		NSProcessInfo* processInfo = [NSProcessInfo processInfo];
		NSString *hostName = processInfo.hostName;
		int pid = processInfo.processIdentifier;
		NSString *globallyUniqueString = processInfo.globallyUniqueString;
		NSString *processName = processInfo.processName;
		NSArray *junks = @[hostName, globallyUniqueString, processName];
		NSString *junk = @"";
		for (int j = 0; j < pid; j++) {
			if (pid % 6 ==0) junk = junks[j % 3];
		}

		if (i % 68 == 1) NSLog(@"Junk: %@", junk);
	}
	NSLog(@"iOSRE: CPPFunction: %s", arg0);
}

extern "C" void CFunction(const char *arg0)
{
	// This for loop makes this function long enough to validate MSHookFunction
	for (int i = 0; i < 66; i++)
	{
		//u_int32_t randomNumber;
		//if (i % 3 == 0) randomNumber = arc4random_uniform(i);
		NSProcessInfo* processInfo = [NSProcessInfo processInfo];
		NSString *hostName = processInfo.hostName;
		int pid = processInfo.processIdentifier;
		NSString *globallyUniqueString = processInfo.globallyUniqueString;
		NSString *processName = processInfo.processName;
		NSArray *junks = @[hostName, globallyUniqueString, processName];
		NSString *junk = @"";
		for (int j = 0; j < pid; j++) {
			if (pid % 6 ==0) junk = junks[j % 3];
		}

		if (i % 68 == 1) NSLog(@"Junk: %@", junk);
	}
	NSLog(@"iOSRE: CFunction: %s", arg0);
}

extern "C" void ShortCFunction(const char *arg0)
{
	CPPClass cppClass;
	cppClass.CPPFunction(arg0);
}


@interface CCRootViewController ()
@property (nonatomic, strong) NSMutableArray * objects;
@end

@implementation CCRootViewController

- (void)loadView {
	[super loadView];

	_objects = [NSMutableArray array];

	self.title = @"Root View Controller";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
}


- (void) viewDidLoad
{
	[super viewDidLoad];

	CPPClass cppClass;
	cppClass.CPPFunction("This is a C++ function.");
	CFunction("This is a C function.");
	ShortCFunction("This a short C function.");
}

- (void)addButtonTapped:(id)sender {
	[_objects insertObject:[NSDate date] atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	NSDate *date = _objects[indexPath.row];
	cell.textLabel.text = date.description;
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[_objects removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
