/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.imageio.ImageIO;
import javax.servlet.http.Part;

/**
 *
 * @author pablo
 */
public class Imagenes {
    //Clase utilizada para trabajar con imágenes
    
    
    public static void guardarImagen(File file, Part fich) throws FileNotFoundException, IOException {
        //recibimos el file y el part y guardamos el fichero
        OutputStream p = new FileOutputStream(file);
        InputStream filecontent;
        filecontent = fich.getInputStream();

        int read = 0;
        final byte[] bytes = new byte[1024];
        while ((read = filecontent.read(bytes)) != -1) {
            p.write(bytes, 0, read);
        }
        p.close();
        filecontent.close();
    }
    
    
    //Codigo cogido de: https://www.codejava.net/java-se/graphics/how-to-resize-images-in-java
     public static void resize(String inputImagePath,
            String outputImagePath, int scaledWidth, int scaledHeight)
            throws IOException {
        // reads input image
        File inputFile = new File(inputImagePath);
        BufferedImage inputImage = ImageIO.read(inputFile);
 
        // creates output image
        BufferedImage outputImage = new BufferedImage(scaledWidth,
                scaledHeight, inputImage.getType());
 
        // scales the input image to the output image
        Graphics2D g2d = outputImage.createGraphics();
        g2d.drawImage(inputImage, 0, 0, scaledWidth, scaledHeight, null);
        g2d.dispose();
 
        // extracts extension of output file
        String formatName = outputImagePath.substring(outputImagePath
                .lastIndexOf(".") + 1);
 
        // writes to output file
        ImageIO.write(outputImage, formatName, new File(outputImagePath));
    }
     
     
     
     
     
}
