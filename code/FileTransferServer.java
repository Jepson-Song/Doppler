import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.math.RoundingMode;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.DecimalFormat;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
 
 /*
cd E:\WorkSpace\project\code
javac -encoding UTF-8 FileTransferServer.java
java FileTransferServer
 */

 /**
 * Created by Jepson on 2020/1/10.
 */
public class FileTransferServer extends ServerSocket {
 
    private static final int SERVER_PORT = 8899; // 服务端端口
 
    private static DecimalFormat df = null;

    private String dirPath = "E:\\WorkSpace\\project\\test\\";//"E:\\GradutionProject\\test\\"; // 存储位置
 
    static {
        // 设置数字格式，保留一位有效小数
        df = new DecimalFormat("#0.0");
        df.setRoundingMode(RoundingMode.HALF_UP);
        df.setMinimumFractionDigits(1);
        df.setMaximumFractionDigits(1);
    }
 
    public FileTransferServer() throws Exception {
        super(SERVER_PORT);
    }
 
    /**
     * 使用线程处理每个客户端传输的文件
     * @throws Exception
     */
    public void load() throws Exception {
        while (true) {
            // server尝试接收其他Socket的连接请求，server的accept方法是阻塞式的
            Socket socket = this.accept();
            /**
             * 我们的服务端处理客户端的连接请求是同步进行的， 每次接收到来自客户端的连接请求后，
             * 都要先跟当前的客户端通信完之后才能再处理下一个连接请求。 这在并发比较多的情况下会严重影响程序的性能，
             * 为此，我们可以把它改为如下这种异步处理与客户端通信的方式
             */
            // 每接收到一个Socket就建立一个新的线程来处理它
            new Thread(new Task(socket)).start();
        }
    }
 
    /**
     * 处理客户端传输过来的文件线程类
     */
    class Task implements Runnable {
 
        private Socket socket;
 
        private DataInputStream dis;
 
        private FileOutputStream fos;
 
        public Task(Socket socket) {
            this.socket = socket;
        }
 
        @Override
        public void run() {
            try {
                System.out.println("==================================================================");
                
                dis = new DataInputStream(socket.getInputStream());
 
                // 文件名和长度
                String fileName = dis.readUTF();
                String dirName = fileName.substring(0,fileName.length()-4);
                long fileLength = dis.readLong();
                File directory = new File(dirPath+dirName);
                if(!directory.exists()) {
                    //创建目录
                    directory.mkdir();
                    System.out.println("======== New Directory                                    ========");
                }
                File file = new File(directory.getAbsolutePath() + File.separatorChar + fileName);
                if(!file.exists()){
                    //创建文件
                    file.createNewFile();
                    System.out.println("======== New File                                         ========");
                }
                fos = new FileOutputStream(file);
 
                // 开始接收文件
                byte[] bytes = new byte[1024];
                int length = 0;
                long progress = 0;
                long startTime=System.currentTimeMillis();   //获取开始时间
                boolean OK = false;
                while(fileLength!=0 && (length = dis.read(bytes, 0, bytes.length)) != -1) {
                    //System.out.println(new String(bytes));
                    fos.write(bytes, 0, length);
                    fos.flush();
                    progress += length;
                    //System.out.printf("传输进度：| %.3f%% |\n",100.0*progress/fileLength);
                    if(progress >= fileLength){
                        OK = true;
                        break;
                    }
                }
                                
                long endTime=System.currentTimeMillis(); //获取结束时间
                if (OK){
                    System.out.println("======== File tansfer successful!                         ========");
                    System.out.println("======== [File Name：" + fileName + "]           ========");
                    System.out.println("======== [Size：" + getFormatFileSize(fileLength) + "]                                  ========");
                    System.out.println("======== [Path：" + dirPath + "]  ========");
                    System.out.println("======== [Time Cost: " + (endTime-startTime)+"ms" + "]                               ========");
                    System.out.println("======== "+fileName.substring(0,fileName.length()-4)+"                            ========");
                    // 发送给客户端的消息 
                    PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())),true);
                    out.println("Send file "+fileName+" successfully!");
                    out.flush();
                    //System.out.println("======== 向客户端反馈成功 ========");
                }
                else {
                    System.out.println("======== File tansfer failed! ========");
                    PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())),true);
                    out.println("Send file "+fileName+" failed!");
                    out.flush();
                    //System.out.println("======== 向客户端反馈成功 ========");
                }
                
                System.out.println("==================================================================");
                System.out.println("");
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if(fos != null)
                        fos.close();
                    if(dis != null)
                        dis.close();
                    socket.close();
                } catch (Exception e) {}
            }
        }
    }
 
    /**
     * 格式化文件大小
     * @param length
     * @return
     */
    private String getFormatFileSize(long length) {
        double size = ((double) length) / (1 << 30);
        if(size >= 1) {
            return df.format(size) + "GB";
        }
        size = ((double) length) / (1 << 20);
        if(size >= 1) {
            return df.format(size) + "MB";
        }
        size = ((double) length) / (1 << 10);
        if(size >= 1) {
            return df.format(size) + "KB";
        }
        return length + "B";
    }
 
    /**
     * 入口
     */
    public static void main(String[] args) {
        try {
            FileTransferServer server = new FileTransferServer(); // 启动服务端
            server.load();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}