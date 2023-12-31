from flask import Flask, jsonify, request
import cv2
import json
import re
import numpy as np
import pytesseract
from PIL import Image
import os

app = Flask(__name__)

# class KTPInformation(object):
#     def __init__(self):
#         self.nik = ""
#         self.nama = ""
#         self.tempat_lahir = ""
#         self.tanggal_lahir = ""
#         self.jenis_kelamin = ""
#         self.golongan_darah = ""
#         self.alamat = ""
#         self.rt = ""
#         self.rw = ""
#         self.kelurahan_atau_desa = ""
#         self.kecamatan = ""
#         self.agama = ""
#         self.status_perkawinan = ""
#         self.pekerjaan = ""
#         self.kewarganegaraan = ""
#         berlaku_hingga = "SEUMUR HIDUP"

class KTPOCR(object):
    # def __init__(self, image):
    #     self.image = cv2.imread(image)
    #     self.gray = cv2.cvtColor(self.image, cv2.COLOR_BGR2GRAY)
    #     self.th, self.threshed = cv2.threshold(self.gray, 127, 255, cv2.THRESH_TRUNC)
    #     self.result = KTPInformation()
    #     self.master_process()

    # def process(self, image):
    #     raw_extracted_text = pytesseract.image_to_string((self.threshed), lang="ind")
    #     return raw_extracted_text

    # def word_to_number_converter(self, word):
    #     word_dict = {'|': "1"}
    #     res = ""
    #     for letter in word:
    #         res += word_dict.get(letter, letter)
    #     return res

    # def nik_extract(self, word):
    #     word_dict = {'b': "6", 'e': "2"}
    #     res = ""
    #     for letter in word:
    #         res += word_dict.get(letter, letter)
    #     return res

    # def extract(self, extracted_result):
    #     for word in extracted_result.split("\n"):
    #         if "NIK" in word:
    #             word = word.split(':')
    #             self.result.nik = self.nik_extract(word[-1].replace(" ", ""))
    #             continue

    #         if "Nama" in word:
    #             word = word.split('Nama :')
    #             self.result.nama = word[-1].replace('Nama ', ' ')
    #             continue

    #         if "Tempat" in word:
    #             word = word.split(':')
    #             self.result.tanggal_lahir = re.search("([0-9]{2}\-[0-9]{2}\-[0-9]{4})", word[-1])[0]
    #             self.result.tempat_lahir = word[-1].replace(self.result.tanggal_lahir, '')
    #             continue

    #         if 'Darah' in word:
    #             self.result.jenis_kelamin = re.search("(LAKI-LAKI|LAKI|LELAKI|PEREMPUAN)", word)[0]
    #             word = word.split(':')
    #             try:
    #                 self.result.golongan_darah = re.search("(O|A|B|AB)", word[-1])[0]
    #             except:
    #                 self.result.golongan_darah = '-'
    #         if 'Alamat' in word:
    #             self.result.alamat = self.word_to_number_converter(word).replace("Alamat ", "")
    #         if 'NO.' in word:
    #             self.result.alamat = self.result.alamat + ' ' + word
    #         if "Kecamatan" in word:
    #             self.result.kecamatan = word.split(':')[1].strip()
    #         if "Desa" in word:
    #             wrd = word.split()
    #             desa = []
    #             for wr in wrd:
    #                 if not 'desa' in wr.lower():
    #                     desa.append(wr)
    #             self.result.kelurahan_atau_desa = ''.join(wr)
    #         if 'Kewarganegaraan' in word:
    #             self.result.kewarganegaraan = word.split(':')[1].strip()
    #         if 'Pekerjaan' in word:
    #             wrod = word.split()
    #             pekerjaan = []
    #             for wr in wrod:
    #                 if not '-' in wr:
    #                     pekerjaan.append(wr)
    #             self.result.pekerjaan = ' '.join(pekerjaan).replace('Pekerjaan', '').strip()
    #         if 'Agama' in word:
    #             self.result.agama = word.replace('Agama', "").strip()
    #         if 'Perkawinan' in word:
    #             self.result.status_perkawinan = word.split(':')[1]
    #         if "RT/RW" in word:
    #             word = word.replace("RT/RW", '')
    #             self.result.rt = word.split('/')[0].strip()
    #             self.result.rw = word.split('/')[1].strip()
            

    # def master_process(self):
    #     raw_text = self.process(self.image)
    #     self.extract(raw_text)

    # def to_json(self):
    #     return json.dumps(self.result.__dict__, indent=4)

    @staticmethod
    def process_image(image_path):
        img = cv2.imread(image_path)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # (2) Threshold
        th, threshed = cv2.threshold(gray, 127, 255, cv2.THRESH_TRUNC)

        # (3) Detect
        result = pytesseract.image_to_string(threshed, lang="ind")

        #menginisisasi variabel
        name = ""
        address = ""
        agama = ""
        kecamatan = ""
        nik = ""
        ttl = ""
        jenis_kelamin = ""
        status_perkawinan = ""
        pekerjaan = ""
        kewarganegaraan = ""
        berlaku_hingga = ""
        

        # (5) Extract only name and address
        for word in result.split("\n"):
            if "Nama" in word:
                name = word.split("Nama")[-1].strip().replace(": ", "")
            elif "Alamat" in word:
                address = word.split("Alamat")[-1].strip().replace(": ", "")
            elif "Agama" in word:
                agama = word.split("Agama")[-1].strip().replace(": ", "").replace("|", "")
            elif "Kecamatan" in word:
                kecamatan = word.split("Kecamatan")[-1].strip().replace(": ", "")
            elif "NIK" in word:
                nik = word.split("NIK")[-1].strip().replace(": ", "")
            elif "Tempat/Tgl Lahir" in word:
                ttl = word.split("Tempat/Tgl Lahir")[-1].strip().replace(": ", "")
            elif "Jenis Kelamin" in word:
                jenis_kelamin = word.split("Jenis Kelamin")[-1].strip().replace(": ", "")  
            elif "Status Perkawinan" in word:
                status_perkawinan = word.split("Status Perkawinan")[-1].strip().replace(": ", "")
            elif "Pekerjaan" in word:
                pekerjaan = word.split("Pekerjaan")[-1].strip().replace(": ", "")
            elif "Kewarganegaraan" in word:
                kewarganegaraan = word.split("Kewarganegaraan")[-1].strip().replace(": ", "")
            elif "Berlaku Hingga" in word:
                berlaku_hingga = word.split("Berlaku Hingga")[-1].strip().replace(": ", "")
          
                
                
        return name, address, agama, kecamatan, nik, ttl, jenis_kelamin, status_perkawinan, pekerjaan, kewarganegaraan, berlaku_hingga
    # ttl, jenis_kelamin, status_perkawinan, pekerjaan, kewarganegaraan,berlaku_hingga