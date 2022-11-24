# Multer

# Client Side Request

```pug
input.form__upload(type='file', accept='image/*' id='photo', name='photo', enctype="multipart/form-data")
label(for='photo') Choose new photo
```

```js
const updateSettings = async (data) => {
  try {
    const res = await fetch('http://{ip}:{port}/api/v1/users/me', {
      method: 'PATCH',
      headers: {}, // browser will fill out header data.
      body: data, // do not JSON encode
    });
    return await res.json();
  } catch (e) {
    console.log(e);
    return e;
  }
};
```

# Fields TypeScript

```ts
import multer from 'multer';
// keep in memory for sharp image processing.
const multerStorage = multer.memoryStorage();
// only images allowed.
const multerFilter = (
  req: Request,
  file: Express.Multer.File,
  cb: multer.FileFilterCallback
) => {
  if (file.mimetype.startsWith('image')) {
    cb(null, true);
  } else {
    cb(new Error('You can only upload images.'));
  }
};
const upload = multer({
  storage: multerStorage,
  fileFilter: multerFilter,
});
// this is multer middleware. It parses multipart form data.
export const uploadTourImages = upload.fields([
  { name: 'imageCover', maxCount: 1 }, // only process an array of 1 image.
  { name: 'images', maxCount: 3 }, // only process an array of 3 images
]);

type ImageType = {
  imageCover?: Express.Multer.File[];
  images?: Express.Multer.File[];
};
interface MulterRequest extends Request {
  files: ImageType;
}
export const resizeTourImages = catchAsync(404, async (req, res, next) => {
  console.log('tourBody', req.body);
  console.log('tourImages', req.files);
  const files = (req as MulterRequest).files;

  if (!files?.imageCover || !files?.images) return next();
  const { imageCover, images } = files;
  // imageCover
  const imageCoverFilename = `tour-${req.params.id}-${Date.now()}-cover.jpeg`;
  await sharp(imageCover[0].buffer)
    .resize(2000, 1333)
    .toFormat('jpeg')
    .jpeg({ quality: 90 })
    .toFile(`public/img/tours/${imageCoverFilename}`);
  req.body.imageCover = imageCoverFilename;

  // images
  req.body.images = await Promise.all(
    images.map((image, i) => {
      const imageName: string = `tour-${req.params.id}-${Date.now()}-${
        i + 1
      }.jpeg`;
      sharp(image.buffer)
        .resize(2000, 1333)
        .toFormat('jpeg')
        .jpeg({ quality: 90 })
        .toFile(`public/img/tours/${imageName}`);
      return imageName;
    })
  );

  next();
});
```
