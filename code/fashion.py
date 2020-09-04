import torch
import torch.nn as nn
from torch.autograd import Variable
from torchvision import transforms
from torch.utils.data import Dataset, DataLoader
from PIL import Image
import time
from torchsummary import summary

root = "E:/WorkSpace/MNIST/fashion_mnist/"

# 超参
use_gpu = False
EPOCH = 20
BACTH_SIZE = 64
LR = 0.001


# -----------------ready the dataset--------------------------
def default_loader(path):
    return Image.open(path).convert('L')


class MyDataset(Dataset):
    def __init__(self, txt, transform=None, target_transform=None, loader=default_loader):
        fh = open(txt, 'r')
        imgs = []
        for line in fh:
            line = line.strip('\n')
            line = line.rstrip()
            words = line.split()
            # print(words)
            imgs.append((words[0], int(words[1][7:-1])))
            # print((words[0], int(words[1][7:-1])))
        self.imgs = imgs
        self.transform = transform
        self.target_transform = target_transform
        self.loader = loader

    def __getitem__(self, index):
        fn, label = self.imgs[index]
        img = self.loader(fn)
        if self.transform is not None:
            img = self.transform(img)
        return img, label

    def __len__(self):
        return len(self.imgs)


train_data = MyDataset(txt=root + 'train.txt', transform=transforms.ToTensor())
test_data = MyDataset(txt=root + 'test.txt', transform=transforms.ToTensor())

train_loader = DataLoader(dataset=train_data, batch_size=BACTH_SIZE, shuffle=True)
test_loader = DataLoader(dataset=test_data, batch_size=BACTH_SIZE)


# test_x = torch.unsqueeze(test_data.data,dim = 1).type(torch.FloatTensor)[:2000]/255
# test_y = test_data.targets[:2000]


# -----------------create the Net and training------------------------

def evaluation(epoch, step):
    model.eval()
    test_loss = 0.
    test_acc = 0.
    for batch_x, batch_y in test_loader:
        batch_x, batch_y = Variable(batch_x, requires_grad=False), Variable(batch_y, requires_grad=False)
        out = model(batch_x)
        loss = loss_func(out, batch_y)
        test_loss += loss.data  # [0]
        pred = torch.max(out, 1)[1].data.numpy()
        num_correct = (pred == batch_y.data.numpy()).astype(int).sum()
        test_acc += num_correct  # .data#[0]

    print("Epoch:%s" % str(epoch), " Step:%s" % str(step), "|test_loss:%.4f" % (test_loss / len(
        test_data)), "|test accuracy:%.2f" % (test_acc / len(test_data)))


class Net(torch.nn.Module):
    def __init__(self):
        super(Net, self).__init__()

        self.conv1 = nn.Sequential(  # input shape(1,28,28)
            nn.Conv2d(
                in_channels=1,  # input height
                out_channels=16,  # n_filters
                kernel_size=5,  # filter size
                stride=1,  # filter movement/step
                padding=2,  # 如果想要 con2d 出来的图片长宽没有变化, padding=(kernel_size-1)/2 当 stride=1
            ),  # output shape (16, 28, 28)
            nn.ELU(),
            nn.MaxPool2d(kernel_size=2),  # output shape(16,14,14)
        )
        self.conv2 = nn.Sequential(
            nn.Conv2d(
                in_channels=16,
                out_channels=32,
                kernel_size=5,
                stride=1,
                padding=2,
            ),  # 32*14*14
            nn.ELU(),
            nn.MaxPool2d(kernel_size=2),  # output shape(32,7,7)
        )
        self.fc1 = nn.Linear(32*7*7, 10)

    def forward(self, x):
        x = self.conv1(x)
        x = self.conv2(x)
        x = x.view(x.size(0), -1)  # 展平多维的卷积图成 (batch_size, 32 * 7 * 7)
        out = self.fc1(x)
        return out

device = torch.device("cpu") # PyTorch v0.4.0
model = Net().to(device)

summary(model, (1, 28, 28))


model = Net()
print(model)

optimizer = torch.optim.Adam(model.parameters(), lr=LR)
loss_func = torch.nn.CrossEntropyLoss()

for epoch in range(EPOCH):
    start = time.time()
    print('epoch {}'.format(epoch))
    # training-----------------------------
    train_loss = 0.
    train_acc = 0.
    for step, (batch_x, batch_y) in enumerate(train_loader):
        batch_x = Variable(batch_x, requires_grad=True)
        batch_y = Variable(batch_y, requires_grad=False)

        out = model(batch_x)

        loss = loss_func(out, batch_y)
        train_loss += loss.data  # [0]
        pred = torch.max(out, 1)[1].data.numpy()
        train_correct = (pred == batch_y.data.numpy()).astype(int).sum()
        train_acc += train_correct  # .data#[0]

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if step % 50 == 0:
            evaluation(epoch, step)

    print("Epoch:%s" % str(epoch), "|train_loss:%.4f" % (train_loss / len(
        train_data)), "|train_acc:%.2f" % (train_acc / len(train_data)))

